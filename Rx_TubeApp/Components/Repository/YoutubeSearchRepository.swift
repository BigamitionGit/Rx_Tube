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
}
