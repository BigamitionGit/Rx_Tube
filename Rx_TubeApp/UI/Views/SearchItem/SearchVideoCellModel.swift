//
//  SearchVideoCellModel.swift
//  Rx_TubeApp
//
//  Created by 細田大志 on 2018/06/22.
//  Copyright © 2018年 HIroshi Hosoda. All rights reserved.
//

import Foundation

struct SearchVideoCellModel {
    let id: String
    let duration: String
    let channelTitle: String
    let likeCount: Int
    let viewCount: Int
    let definition: String
    let publishedAt: String
    let title: String
    let thumbnailUrl: String
    
    
    init(video: Videos.Item, channel: Channels.Item) {
    
        let snippet = video.snippet!
        let statistics = video.statistics!
        let contentsDetail = video.contentDetails!
        
        id = video.id
        duration = contentsDetail.duration
        channelTitle = snippet.channelTitle
        likeCount = statistics.likeCount
        viewCount = statistics.viewCount
        definition = contentsDetail.definition
        publishedAt = snippet.publishedAt
        title = snippet.title
        thumbnailUrl = snippet.thumbnails.default.url
    }
}
