//
//  SearchVideoCell.swift
//  Rx_TubeApp
//
//  Created by 細田大志 on 2018/06/22.
//  Copyright © 2018年 HIroshi Hosoda. All rights reserved.
//

import UIKit

final class SearchVideoCell: BaseTableViewCell {
    static let identifier = String(describing: SearchVideoCell.self)
    
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
    
    private let footerView = UIView()
    
    override func initialize() {
        [titleLabel, publishedAtLabel].forEach {
            footerView.addSubview($0)
        }
        [thumbnail, footerView, channelTitleLabel]
            .forEach { self.contentView.addSubview($0) }
    }
    
    // MARK: Constraining
    
    private func setConstraint() {
    }
    
    // MARK: Configuring
    
    func config(model: SearchVideoCellModel) {
        titleLabel.text = model.title
        publishedAtLabel.text = model.publishedAt
        channelTitleLabel.text = model.channelTitle
        
        setConstraint()
    }
}
