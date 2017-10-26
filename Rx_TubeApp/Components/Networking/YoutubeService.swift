//
//  YoutubeService.swift
//  Rx_TubeApp
//
//  Created by 細田　大志 on 2017/10/23.
//  Copyright © 2017 HIroshi Hosoda. All rights reserved.
//

import RxSwift
import RxMoya

protocol YoutubeServiceType {
    var event: PublishSubject<YoutubeService.Event> { get }
    
    var fetchSearchItems:(YoutubeAPI.RequireParameter.Search, Set<YoutubeAPI.FilterParameter.Search>)->Observable<SearchItems> { get }
    var fetchVideos:(YoutubeAPI.RequireParameter.Videos, YoutubeAPI.FilterParameter.Videos)->Observable<Videos>  { get }
    var fetchChannels:(YoutubeAPI.RequireParameter.Channels, YoutubeAPI.FilterParameter.Channels)->Observable<Channels> { get }
    var fetchPlaylists:(YoutubeAPI.RequireParameter.Playlists, YoutubeAPI.FilterParameter.Playlists)->Observable<Playlists> { get }
}

final class YoutubeService: YoutubeServiceType {
    
    let fetchSearchItems: (YoutubeAPI.RequireParameter.Search, Set<YoutubeAPI.FilterParameter.Search>) -> Observable<SearchItems>
    let fetchVideos: (YoutubeAPI.RequireParameter.Videos, YoutubeAPI.FilterParameter.Videos) -> Observable<Videos>
    let fetchChannels: (YoutubeAPI.RequireParameter.Channels, YoutubeAPI.FilterParameter.Channels) -> Observable<Channels>
    let fetchPlaylists: (YoutubeAPI.RequireParameter.Playlists, YoutubeAPI.FilterParameter.Playlists) -> Observable<Playlists>
    
    enum Event {
        case favorite
        case like
    }
    
    let event = PublishSubject<Event>()
    
    init(provider: RxMoyaProvider<YoutubeAPI>) {
        
        fetchSearchItems = { require, filter in
            return provider.request(YoutubeAPI.search(require: require, filter: filter))
                .retry(3)
                .map(SearchItems.self)
        }
        
        fetchVideos = { require, filter in
            return provider.request(YoutubeAPI.videos(require: require, filter: filter))
                .retry(3)
                .map(Videos.self)
        }
        
        fetchChannels = { require, filter in
            return provider.request(YoutubeAPI.channels(require: require, filter: filter))
                .retry(3)
                .map(Channels.self)
        }
        
        fetchPlaylists = { require, filter in
            return provider.request(YoutubeAPI.playlists(require: require, filter: filter))
                .retry(3)
                .map(Playlists.self)
        }
        
    }
}
