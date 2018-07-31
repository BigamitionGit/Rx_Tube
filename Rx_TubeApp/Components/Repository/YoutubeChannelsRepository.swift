//
//  YoutubeChannelsRepository.swift
//  Rx_TubeApp
//
//  Created by 細田大志 on 2018/06/20.
//  Copyright © 2018年 HIroshi Hosoda. All rights reserved.
//

import RxSwift
import RxMoya
import Moya

protocol YoutubeChannelsRepositoryType {
    func fetchChannels(require: YoutubeAPI.RequireParameter.Channels, filter: YoutubeAPI.FilterParameter.Channels)->Single<Channels>
    
    func fetchChannel(require: YoutubeAPI.RequireParameter.Channels, channelId: String)->Single<Channels.Item>
}

final class YoutubeChannelsRepository: YoutubeChannelsRepositoryType {
    
    private let provider: MoyaProvider<YoutubeAPI>
    
    init(provider: MoyaProvider<YoutubeAPI>) {
        self.provider = provider
    }
    
    func fetchChannels(require: YoutubeAPI.RequireParameter.Channels, filter: YoutubeAPI.FilterParameter.Channels) -> PrimitiveSequence<SingleTrait, Channels> {
        return provider.rx.request(YoutubeAPI.channels(require: require, filter: filter))
            .map(Channels.self)
    }
    
    // TODO: Because crash in case [], return default value in case []
    func fetchChannel(require: YoutubeAPI.RequireParameter.Channels, channelId: String) -> PrimitiveSequence<SingleTrait, Channels.Item> {
        return provider.rx.request(YoutubeAPI.channels(require: require, filter: .id(ids: [channelId])))
            .map(Channels.self)
            .map { (channels: Channels)->Channels.Item in channels.items.first! }
    }
}
