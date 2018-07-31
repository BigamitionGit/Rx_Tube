//
//  YoutubeSearchDetailsRepository.swift
//  Rx_TubeApp
//
//  Created by 細田大志 on 2018/07/31.
//  Copyright © 2018年 HIroshi Hosoda. All rights reserved.
//

import RxSwift
import RxMoya
import Moya

protocol YoutubeSearchDetailsRepositoryType {
    
    func fetchSearchItemDetails(_ ids: [(itemId: SearchItemId, channelId: String)])->Single<SearchItemDetails>
}

final class YoutubeSearchDetailsRepository: YoutubeSearchDetailsRepositoryType {
    
    let provider: MoyaProvider<YoutubeAPI>
    
    init(provider: MoyaProvider<YoutubeAPI>) {
        self.provider = provider
    }
    
    func fetchSearchItemDetails(_ ids: [(itemId: SearchItemId, channelId: String)]) -> Single<SearchItemDetails> {
        let videoIds = ids.filter { $0.itemId.kind == .video }.map { $0.itemId.searchItemId }
        let channelIds = ids.map { $0.channelId }
        let playlistIds = ids.filter { $0.itemId.kind == .playlist }.map { $0.itemId.searchItemId }
        
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
        
        let fetchPlaylists = provider
            .rx.request(YoutubeAPI.playlists(
                require: YoutubeAPI.RequireParameter.Playlists(properties: [.snippet, .contentDetails, .player]),
                filter: YoutubeAPI.FilterParameter.Playlists.id(ids: playlistIds)))
            .map(Playlists.self)
        
        return Single
            .zip(
                fetchVideos,
                fetchChannels,
                fetchPlaylists) { videos, channels, playlists->SearchItemDetails in
                    
                    let toDetails: (SearchItemId, String)-> SearchItemDetails.ItemType? = { itemId, channelId in
                        switch itemId.kind {
                        case .video:
                            guard let v = videos.items.first(where: { $0.id == itemId.searchItemId }),
                                let c = channels.items.first(where: { $0.id == channelId }),
                                let video = SearchItemDetails.Video(video: v, channel: c) else { return nil }
                            return SearchItemDetails.ItemType.video(video)
                        case .channel:
                            guard let channel = channels.items.first(where: { $0.id == itemId.searchItemId })
                                .flatMap(SearchItemDetails.Channel.init)  else { return nil }
                            return SearchItemDetails.ItemType.channel(channel)
                        case .playlist:
                            guard let p = playlists.items.first(where: { $0.id == itemId.searchItemId }),
                                let c = channels.items.first(where: { $0.id == channelId }),
                                let playlist = SearchItemDetails.Playlist(playlist: p, channel: c) else { return nil }
                            return SearchItemDetails.ItemType.playlist(playlist)
                        }
                    }
                    
                    return SearchItemDetails(items: ids.compactMap(toDetails))
                    
        }
    }
}
