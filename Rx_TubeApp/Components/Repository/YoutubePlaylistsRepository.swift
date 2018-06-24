//
//  YoutubePlaylistsRepository.swift
//  Rx_TubeApp
//
//  Created by 細田大志 on 2018/06/20.
//  Copyright © 2018年 HIroshi Hosoda. All rights reserved.
//

import RxSwift
import RxMoya
import Moya

protocol YoutubePlaylistsRepositoryType {
    var fetchPlaylists:(YoutubeAPI.RequireParameter.Playlists, YoutubeAPI.FilterParameter.Playlists)->Single<Playlists> { get }
}

final class YoutubePlaylistsRepository: YoutubePlaylistsRepositoryType {
    
    let fetchPlaylists: (YoutubeAPI.RequireParameter.Playlists, YoutubeAPI.FilterParameter.Playlists) -> Single<Playlists>
    
    
    init(provider: MoyaProvider<YoutubeAPI>) {
        
        fetchPlaylists = { require, filter in
            return provider.rx.request(YoutubeAPI.playlists(require: require, filter: filter))
                .retry(3)
                .map(Playlists.self)
        }
    }
    
}

