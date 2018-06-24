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
    var fetchChannels:(YoutubeAPI.RequireParameter.Channels, YoutubeAPI.FilterParameter.Channels)->Single<Channels> { get }
    
    var fetchChannel:(YoutubeAPI.RequireParameter.Channels,_ channelId: String)->Single<Channels.Item> { get }
}

final class YoutubeChannelsRepository: YoutubeChannelsRepositoryType {
    
    let fetchChannels: (YoutubeAPI.RequireParameter.Channels, YoutubeAPI.FilterParameter.Channels) -> Single<Channels>
    let fetchChannel: (YoutubeAPI.RequireParameter.Channels, _ channelId: String) -> Single<Channels.Item>
    
    
    init(provider: MoyaProvider<YoutubeAPI>) {
        
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
    }
    
}


