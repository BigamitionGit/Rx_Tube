//
//  SearchItemCell.swift
//  Rx_TubeApp
//
//  Created by 細田　大志 on 2017/07/22.
//  Copyright © 2017 HIroshi Hosoda. All rights reserved.
//

import Foundation
import UIKit

protocol SearchItemCellType {
    func config(item: SearchItemCellModel)
}

extension SearchItemCellType where Self:UITableViewCell {
}

final class VideoItemCell: UITableViewCell, SearchItemCellType {
    static let identifier = String(describing: VideoItemCell.self)
    
    func config(item: SearchItemCellModel) {
        
    }
}

final class ChannelItemCell: UITableViewCell, SearchItemCellType {
    static let identifier = String(describing: ChannelItemCell.self)
    
    func config(item: SearchItemCellModel) {
        
    }
}

final class PlaylistItemCell: UITableViewCell, SearchItemCellType {
    static let identifier = String(describing: PlaylistItemCell.self)
    
    func config(item: SearchItemCellModel) {
        
    }
}
