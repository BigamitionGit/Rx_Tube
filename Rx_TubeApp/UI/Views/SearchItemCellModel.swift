//
//  SearchItemCellModel.swift
//  Rx_TubeApp
//
//  Created by 細田　大志 on 2017/07/26.
//  Copyright © 2017 HIroshi Hosoda. All rights reserved.
//

import Foundation

struct SearchItemCellModel {
    
    enum ItemType {
        case video(id: String)
        case channel(id: String)
        case playlist(id: String)
        
        init?(itemId: SearchItems.Item.Id) {
            if let video = itemId.videoId {
                self = .video(id: video)
            } else if let channel = itemId.channelId {
                self = .channel(id: channel)
            } else if let playlist = itemId.playlistId {
                self = .playlist(id: playlist)
            } else { return nil }
        }
        
        var id: String {
            switch self {
            case .video(let id):
                return id
            case .channel(let id):
                return id
            case .playlist(let id):
                return id
            }
        }
    }
    
    let type: ItemType
    let publishedAt: String
    let title: String
    let thumbnailUrl: String
    let channelTitle: String
    
    init?(item: SearchItems.Item) {
        guard let itemType = ItemType(itemId: item.id) else { return nil }
        type = itemType
        let snippet = item.snippet
        publishedAt = snippet.publishedAt
        title = snippet.title
        thumbnailUrl = snippet.thumbnails.default.url
        channelTitle = snippet.channelTitle
    }
}
