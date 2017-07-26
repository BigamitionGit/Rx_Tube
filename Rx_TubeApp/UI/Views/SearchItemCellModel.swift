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
        case video
        case channel
        case playlist
    }
    
    let type: ItemType
    let publishedAt: Date
    let title: String
    let thumbnailUrl: String
    let channelTitle: String
    
    
}
