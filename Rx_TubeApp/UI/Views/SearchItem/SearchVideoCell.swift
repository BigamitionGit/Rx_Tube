//
//  SearchVideoCell.swift
//  Rx_TubeApp
//
//  Created by 細田大志 on 2018/06/22.
//  Copyright © 2018年 HIroshi Hosoda. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

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
        thumbnail.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(thumbnail.snp.width).multipliedBy(16 / 9)
            make.left.equalTo(self.contentView)
            make.right.equalTo(self.contentView)
            make.top.equalTo(self.contentView)
        }
        footerView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(thumbnail.snp.bottom)
            make.left.equalTo(self.contentView)
            make.right.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
        }
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(footerView)
            make.left.equalTo(footerView)
            make.right.equalTo(publishedAtLabel.snp.left).offset(8)
            make.bottom.equalTo(footerView)
        }
        publishedAtLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(footerView)
            make.right.equalTo(footerView)
            make.width.equalTo(80) // TODO: 文字列から幅を計算
            make.bottom.equalTo(titleLabel.snp.bottom)
        }
    }
    
    // MARK: Configuring
    
    func config(model: SearchVideoCellModel) {
        titleLabel.text = model.title
        publishedAtLabel.text = model.publishedAt
        channelTitleLabel.text = model.channelTitle
        thumbnail.kf.setImage(with: URL(string: model.thumbnailUrl))
        
        setConstraint()
    }
}
