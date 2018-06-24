//
//  SearchChannelCellModel.swift
//  Rx_TubeApp
//
//  Created by 細田大志 on 2018/06/22.
//  Copyright © 2018年 HIroshi Hosoda. All rights reserved.
//

import Foundation

struct SearchChannelCellModel {
    let id: String
    let subscriberCount: Int
    let videoCount: Int
    let publishedAt: String
    let title: String
    let thumbnailUrl: String
    
    
    init(channel: Channels.Item) {
        
        let snippet = channel.snippet!
        let statistics = channel.statistics!
        
        id = channel.id
        subscriberCount = statistics.subscriberCount
        videoCount = statistics.videoCount
        publishedAt = snippet.publishedAt
        title = snippet.title
        thumbnailUrl = snippet.thumbnails.default.url
    }
}
