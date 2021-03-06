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
    
    func fetchVideo(require: YoutubeAPI.RequireParameter.Videos, videoId: String)->Single<Videos.Item>
}

final class YoutubeVideosRepository: YoutubeVideosRepositoryType {
    
    private let provider: MoyaProvider<YoutubeAPI>
    
    init(provider: MoyaProvider<YoutubeAPI>) {
        self.provider = provider
    }
    
    func fetchVideos(require: YoutubeAPI.RequireParameter.Videos, filter: YoutubeAPI.FilterParameter.Videos) -> Single<Videos> {
        return provider.rx.request(YoutubeAPI.videos(require: require, filter: filter))
            .map(Videos.self)
    }
    
    // TODO: Because crash in case [], return default value in case []
    func fetchVideo(require: YoutubeAPI.RequireParameter.Videos, videoId: String) -> PrimitiveSequence<SingleTrait, Videos.Item> {
        return provider.rx.request(YoutubeAPI.videos(require: require, filter: .id(ids: [videoId])))
            .map(Videos.self)
            .map { (videos: Videos)->Videos.Item in videos.items.first! }
    }
    
}
