//
//  YoutubeVideosRepository.swift
//  Rx_TubeApp
//
//  Created by 細田大志 on 2018/06/20.
//  Copyright © 2018年 HIroshi Hosoda. All rights reserved.
//

import RxSwift
import RxMoya
import Moya

protocol YoutubeVideosRepositoryType {
    func fetchVideos(require: YoutubeAPI.RequireParameter.Videos, filter: YoutubeAPI.FilterParameter.Videos)->Single<Videos>
    
    func fetchRelatedVideos(videoId: String)->Single<[SearchItemDetails.Video]>
    
    func fetchVideo(require: YoutubeAPI.RequireParameter.Videos, videoId: String)->Single<Videos.Item>
}

final class YoutubeVideosRepository: YoutubeVideosRepositoryType {
    
    let provider: MoyaProvider<YoutubeAPI>
    
    
    init(provider: MoyaProvider<YoutubeAPI>) {
        self.provider = provider
    }
    
    func fetchVideos(require: YoutubeAPI.RequireParameter.Videos, filter: YoutubeAPI.FilterParameter.Videos) -> Single<Videos> {
        return provider.rx.request(YoutubeAPI.videos(require: require, filter: filter))
            .map(Videos.self)
    }
    
    func fetchRelatedVideos(videoId: String) -> Single<[SearchItemDetails.Video]> {
        let require = YoutubeAPI.RequireParameter.Search(properties: [.id, .snippet])
        let filter = YoutubeAPI.FilterParameter.Search.relatedToVideoId(id: videoId)
        let options = Set<YoutubeAPI.OptionParameter.Search>()
        
        return provider.rx.request(YoutubeAPI.search(require: require, filter: filter, option: options))
            .map(SearchItems.self)
            .flatMap { [provider] searchItems in
                let videoIds = searchItems.items.map { $0.id.searchItemId }
                let channelIds = searchItems.items.map { $0.snippet.channelId }
                
                let fetchVideos = provider
                    .rx.request(YoutubeAPI.videos(
                        require: YoutubeAPI.RequireParameter.Videos(properties: [.snippet, .statistics, .player]),
                        filter: YoutubeAPI.FilterParameter.Videos.id(ids: videoIds)))
                    .map(Videos.self)
                
                let fetchChannels = provider
                    .rx.request(YoutubeAPI.channels(
                        require: YoutubeAPI.RequireParameter.Channels(properties: [.snippet, .contentDetails, .statistics]),
                        filter: YoutubeAPI.FilterParameter.Channels.id(ids: channelIds)))
                    .map(Channels.self)
                
                return Single.zip(fetchVideos, fetchChannels) { videos, channels in
                    searchItems.items.compactMap { item in
                        guard let video = videos.items.first(where: { $0.id == item.id.searchItemId }) else { return nil }
                        guard let channel = channels.items.first(where: { $0.id == item.snippet.channelId }) else { return nil }
                        return SearchItemDetails.Video(video: video, channel: channel)
                    }
                }
        }
    }
    
    // TODO: Because crash in case [], return default value in case []
    func fetchVideo(require: YoutubeAPI.RequireParameter.Videos, videoId: String) -> PrimitiveSequence<SingleTrait, Videos.Item> {
        return provider.rx.request(YoutubeAPI.videos(require: require, filter: .id(ids: [videoId])))
            .map(Videos.self)
            .map { (videos: Videos)->Videos.Item in videos.items.first! }
    }
    
}

