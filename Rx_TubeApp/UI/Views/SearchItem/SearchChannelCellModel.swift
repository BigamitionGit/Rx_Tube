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
    
    
    init(channel: SearchItemDetails.Channel) {
        
        id = channel.id
        subscriberCount = channel.statistics.subscriberCount
        videoCount = channel.statistics.videoCount
        publishedAt = channel.snippet.publishedAt
        title = channel.snippet.title
        thumbnailUrl = channel.snippet.thumbnails.default.url
    }
}
