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
    func fetchPlaylists(require: YoutubeAPI.RequireParameter.Playlists, filter: YoutubeAPI.FilterParameter.Playlists)->Single<Playlists>
}

final class YoutubePlaylistsRepository: YoutubePlaylistsRepositoryType {
    
    private let provider: MoyaProvider<YoutubeAPI>
    
    init(provider: MoyaProvider<YoutubeAPI>) {
        self.provider = provider
    }
    
    func fetchPlaylists(require: YoutubeAPI.RequireParameter.Playlists, filter: YoutubeAPI.FilterParameter.Playlists) -> PrimitiveSequence<SingleTrait, Playlists> {
        return provider.rx.request(YoutubeAPI.playlists(require: require, filter: filter))
            .map(Playlists.self)
    }
}
