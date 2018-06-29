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
        case video(SearchVideoCellModel)
        case channel(SearchChannelCellModel)
        case playlist(SearchPlaylistCellModel)
    }
    
    let items: [ItemType]
    
    init(model: SearchItemDetails) {
        
        items = model.items
            .map { item in
                switch (item) {
                case .video(let video):
                    return ItemType.video(SearchVideoCellModel(video: video))
                case .channel(let channel):
                    return ItemType.channel(SearchChannelCellModel(channel: channel))
                case .playlist(let playlist):
                    return ItemType.playlist(SearchPlaylistCellModel(playlist: playlist))
                }
        }
    }
}
