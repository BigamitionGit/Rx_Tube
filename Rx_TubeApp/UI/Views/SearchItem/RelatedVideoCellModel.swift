//
//  RelatedVideoCellModel.swift
//  Rx_TubeApp
//
//  Created by 細田　大志 on 2017/11/18.
//  Copyright © 2017 HIroshi Hosoda. All rights reserved.
//


final class RelatedVideoCellModel {
    let publishedAt: String
    let title: String
    let thumbnailUrl: String
    let channelTitle: String
    
    init(item: SearchItems.Item.Snippet) {
        publishedAt = item.publishedAt
        title = item.title
        thumbnailUrl = item.thumbnails.default.url
        channelTitle = item.channelTitle
    }
}
