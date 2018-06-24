//
//  YoutubeSearchRepository.swift
//  Rx_TubeApp
//
//  Created by 細田大志 on 2018/05/16.
//  Copyright © 2018年 HIroshi Hosoda. All rights reserved.
//

import RxSwift
import RxMoya
import Moya

protocol YoutubeSearchRepositoryType {
    func fetchSearchItems(_ options: Set<YoutubeAPI.OptionParameter.Search>)->Single<SearchItems>
    
    func fetchSearchItemDetails(_ ids: [(itemId: SearchItemId, channelId: String)])->Single<SearchItemDetails>
}

final class YoutubeSearchRepository: YoutubeSearchRepositoryType {
    
    let provider: MoyaProvider<YoutubeAPI>
    
    
    init(provider: MoyaProvider<YoutubeAPI>) {
        self.provider = provider
    }
    
    func fetchSearchItems(_ options: Set<YoutubeAPI.OptionParameter.Search>)->Single<SearchItems> {
        let require = YoutubeAPI.RequireParameter.Search(properties: [.id, .snippet])
        return provider
            .rx.request(YoutubeAPI.search(require: require, filter: nil, option: options))
            .map(SearchItems.self)
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
                        guard let video = videos.items.first(where: { $0.id == itemId.searchItemId }), let channel = channels.items.first(where: { $0.id == channelId }) else { return nil }
                        return SearchItemDetails.ItemType.video(video: video, channel: channel)
                    case .channel:
                        guard let channel = channels.items.first(where: { $0.id == itemId.searchItemId }) else { return nil }
                        return SearchItemDetails.ItemType.channel(channel: channel)
                    case .playlist:
                        guard let playlist = playlists.items.first(where: { $0.id == itemId.searchItemId }), let channel = channels.items.first(where: { $0.id == channelId }) else { return nil }
                        return SearchItemDetails.ItemType.playlist(playlist: playlist, channel: channel)
                    }
                }
            
                return SearchItemDetails(items: ids.compactMap(toDetails))
                
        }
    }
    
}
