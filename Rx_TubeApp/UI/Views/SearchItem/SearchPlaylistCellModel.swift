//
//  SearchPlaylistCellModel.swift
//  Rx_TubeApp
//
//  Created by 細田大志 on 2018/06/22.
//  Copyright © 2018年 HIroshi Hosoda. All rights reserved.
//

import Foundation

struct SearchPlaylistCellModel {
    let id: String
    let channelTitle: String
    let itemCount: Int
    let publishedAt: String
    let title: String
    let thumbnailUrl: String
    
    
    init(playlist: Playlists.Item, channel: Channels.Item) {
        
        let snippet = playlist.snippet!
        let contentDetails = playlist.contentDetails!
        
        id = playlist.id
        channelTitle = snippet.channelTitle
        itemCount = contentDetails.itemCount
        publishedAt = snippet.publishedAt
        title = snippet.title
        thumbnailUrl = snippet.thumbnails.default.url
    }
}
