//
//  YoutubeService.swift
//  Rx_TubeApp
//
//  Created by 細田　大志 on 2017/10/23.
//  Copyright © 2017 HIroshi Hosoda. All rights reserved.
//

import RxSwift
import RxMoya
import Moya

protocol YoutubeServiceType {
    var event: PublishSubject<YoutubeService.Event> { get }
    
    /// Search
    
    var fetchSearchItems:(YoutubeAPI.RequireParameter.Search, YoutubeAPI.FilterParameter.Search?, Set<YoutubeAPI.OptionParameter.Search>)->Single<SearchItems> { get }
    
    /// Video
    
    var fetchVideos:(YoutubeAPI.RequireParameter.Videos, YoutubeAPI.FilterParameter.Videos)->Single<Videos>  { get }
    
    var fetchVideo:(YoutubeAPI.RequireParameter.Videos,_ videoId: String)->Single<Videos.Item> { get }
    
    /// Channel
    
    var fetchChannels:(YoutubeAPI.RequireParameter.Channels, YoutubeAPI.FilterParameter.Channels)->Single<Channels> { get }
    
    var fetchChannel:(YoutubeAPI.RequireParameter.Channels,_ channelId: String)->Single<Channels.Item> { get }
    
    /// Playlist
    
    var fetchPlaylists:(YoutubeAPI.RequireParameter.Playlists, YoutubeAPI.FilterParameter.Playlists)->Single<Playlists> { get }
}

final class YoutubeService: YoutubeServiceType {
    
    enum Event {
        case favorite
        case like
    }
    
    let fetchSearchItems: (YoutubeAPI.RequireParameter.Search, YoutubeAPI.FilterParameter.Search?, Set<YoutubeAPI.OptionParameter.Search>) -> Single<SearchItems>
    
    let fetchVideos: (YoutubeAPI.RequireParameter.Videos, YoutubeAPI.FilterParameter.Videos) -> Single<Videos>
    let fetchVideo: (YoutubeAPI.RequireParameter.Videos, _ videoId: String) -> Single<Videos.Item>
    
    let fetchChannels: (YoutubeAPI.RequireParameter.Channels, YoutubeAPI.FilterParameter.Channels) -> Single<Channels>
    let fetchChannel: (YoutubeAPI.RequireParameter.Channels, _ channelId: String) -> Single<Channels.Item>
    
    let fetchPlaylists: (YoutubeAPI.RequireParameter.Playlists, YoutubeAPI.FilterParameter.Playlists) -> Single<Playlists>
    
    let event = PublishSubject<Event>()
    
    init(provider: MoyaProvider<YoutubeAPI>) {
        
        fetchSearchItems = { require, filter, options in
            return provider.rx.request(YoutubeAPI.search(require: require, filter: filter, option: options))
                .retry(3)
                .map(SearchItems.self)
        }
        
        fetchVideos = { require, filter in
            return provider.rx.request(YoutubeAPI.videos(require: require, filter: filter))
                .retry(3)
                .map(Videos.self)
        }
        
        // TODO: Because crash in case [], return default value in case []
        fetchVideo = { require, videoId in
            return provider.rx.request(YoutubeAPI.videos(require: require, filter: .id(ids: [videoId])))
                .retry(3)
                .map(Videos.self)
                .map { (videos: Videos)->Videos.Item in videos.items.first! }
        }
        
        fetchChannels = { require, filter in
            return provider.rx.request(YoutubeAPI.channels(require: require, filter: filter))
                .retry(3)
                .map(Channels.self)
        }
        
        // TODO: Because crash in case [], return default value in case []
        fetchChannel = { require, channelId in
            return provider.rx.request(YoutubeAPI.channels(require: require, filter: .id(ids: [channelId])))
                .retry(3)
                .map(Channels.self)
                .map { (channels: Channels)->Channels.Item in channels.items.first! }
        }
        
        fetchPlaylists = { require, filter in
            return provider.rx.request(YoutubeAPI.playlists(require: require, filter: filter))
                .retry(3)
                .map(Playlists.self)
        }
        
    }
}
