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
    
    
    init(video: SearchItemDetails.Video) {
        
        id = video.id
        duration = video.contentDetails.duration
        channelTitle = video.snippet.channelTitle
        likeCount = video.statistics.likeCount
        viewCount = video.statistics.viewCount
        definition = video.contentDetails.definition
        publishedAt = video.snippet.publishedAt
        title = video.snippet.title
        thumbnailUrl = video.snippet.thumbnails.default.url
    }
}
