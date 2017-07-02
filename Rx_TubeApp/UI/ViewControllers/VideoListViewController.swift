//
//  VideoListViewController.swift
//  Rx_TubeApp
//
//  Created by Hiroshi Hosoda on 2017/06/15.
//  Copyright © 2017年 HIroshi Hosoda. All rights reserved.
//

import UIKit
import SnapKit

class VideoListViewController: UIViewController {
    
    private let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: nil)
    private lazy var videoListView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = searchButton
        self.view.addSubview(videoListView)
        setupConstraint()
    }
    
    private func setupConstraint() {
        self.videoListView.snp.makeConstraints({ make in
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(0)
//            make.left.equalTo			
        })
        
    }

}
