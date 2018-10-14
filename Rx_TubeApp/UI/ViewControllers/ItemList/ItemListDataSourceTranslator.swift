//
//  ItemListDataSourceTranslator.swift
//  Rx_TubeApp
//
//  Created by 細田大志 on 2018/10/14.
//  Copyright © 2018 HIroshi Hosoda. All rights reserved.
//

import Foundation

protocol ItemListDataSourceTranslatorType {
    func translate(model: SearchItemDetails) -> [SearchItemCellModel]
}

struct ItemListDataSourceTranslator: ItemListDataSourceTranslatorType {
    
    func translate(model: SearchItemDetails) -> [SearchItemCellModel] {
        return model.items
            .map { item -> SearchItemCellModel in
                switch (item) {
                case .video(let video):
                    return SearchItemCellModel.video(SearchVideoCellModel(video: video))
                case .channel(let channel):
                    return SearchItemCellModel.channel(SearchChannelCellModel(channel: channel))
                case .playlist(let playlist):
                    return SearchItemCellModel.playlist(SearchPlaylistCellModel(playlist: playlist))
                }
        }
    }
}
