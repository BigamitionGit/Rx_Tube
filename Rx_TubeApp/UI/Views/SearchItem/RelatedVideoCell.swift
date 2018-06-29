//
//  RelatedVideoCell.swift
//  Rx_TubeApp
//
//  Created by 細田　大志 on 2017/11/18.
//  Copyright © 2017 HIroshi Hosoda. All rights reserved.
//

import UIKit

class RelatedVideoCell: BaseTableViewCell {

    static let identifier = String(describing: RelatedVideoCell.self)
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.green
        return label
    }()
    private lazy var thumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.blue
        return imageView
    }()
    private lazy var publishedAtLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    private lazy var channelTitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override func initialize() {
        [thumbnail, titleLabel, publishedAtLabel, channelTitleLabel]
            .forEach { self.contentView.addSubview($0) }
    }
    
    func config(item: RelatedVideoCellModel) {
        
    }

}
