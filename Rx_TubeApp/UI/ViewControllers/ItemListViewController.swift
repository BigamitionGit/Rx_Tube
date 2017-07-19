//
//  ItemListViewController.swift
//  Rx_TubeApp
//
//  Created by 細田　大志 on 2017/07/11.
//  Copyright © 2017 HIroshi Hosoda. All rights reserved.
//

import UIKit
import SnapKit

final class ItemListViewController: UIViewController {

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
