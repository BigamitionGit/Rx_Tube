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
    
    
    init(playlist: SearchItemDetails.Playlist) {
        
        id = playlist.id
        channelTitle = playlist.snippet.channelTitle
        itemCount = playlist.contentDetails.itemCount
        publishedAt = playlist.snippet.publishedAt
        title = playlist.snippet.title
        thumbnailUrl = playlist.snippet.thumbnails.default.url
    }
}
