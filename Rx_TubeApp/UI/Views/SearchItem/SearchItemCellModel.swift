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
                case .video(let video, let channel):
                    return ItemType.video(SearchVideoCellModel(video: video, channel: channel))
                case .channel(let channel):
                    return ItemType.channel(SearchChannelCellModel(channel: channel))
                case .playlist(let playlist, let channel):
                    return ItemType.playlist(SearchPlaylistCellModel(playlist: playlist, channel: channel))
                }
        }
    }
}
