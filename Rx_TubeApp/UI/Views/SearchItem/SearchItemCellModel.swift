//
//  SearchItemCellModel.swift
//  Rx_TubeApp
//
//  Created by 細田　大志 on 2017/07/26.
//  Copyright © 2017 HIroshi Hosoda. All rights reserved.
//

import Foundation

enum SearchItemCellModel {
    case video(SearchVideoCellModel)
    case channel(SearchChannelCellModel)
    case playlist(SearchPlaylistCellModel)
}
