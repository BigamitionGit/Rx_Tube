//
//  SearchItemCell.swift
//  Rx_TubeApp
//
//  Created by 細田　大志 on 2017/07/22.
//  Copyright © 2017 HIroshi Hosoda. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

final class VideoItemCell: BaseTableViewCell {
    static let identifier = String(describing: VideoItemCell.self)
    
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
    
    func config(item: SearchItemCellModel.Video) {
        titleLabel.text = item.title
        publishedAtLabel.text = item.publishedAt
        channelTitleLabel.text = item.channelTitle
        thumbnail.kf.setImage(with: URL(string: item.thumbnailUrl))
        
        setConstraint()
    }
}

final class ChannelItemCell: BaseTableViewCell {
    static let identifier = String(describing: ChannelItemCell.self)
    
    func config(item: SearchItemCellModel.Channel) {
        
    }
}

final class PlaylistItemCell: BaseTableViewCell {
    static let identifier = String(describing: PlaylistItemCell.self)
    
    func config(item: SearchItemCellModel.Playlist) {
        
    }
}
