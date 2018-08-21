//
//  ItemListViewController.swift
//  Rx_TubeApp
//
//  Created by 細田　大志 on 2017/07/11.
//  Copyright © 2017 HIroshi Hosoda. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ItemListViewController: UIViewController {
    
    private let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: nil)
    private lazy var videoListView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(SearchVideoCell.self, forCellReuseIdentifier: SearchVideoCell.identifier)
        tableView.register(SearchChannelCell.self, forCellReuseIdentifier: SearchChannelCell.identifier)
        tableView.register(SearchPlaylistCell.self, forCellReuseIdentifier: SearchPlaylistCell.identifier)
        return tableView
    }()
    
    private let dataSource = DataSource()
    private let disposeBag = DisposeBag()
    
    // MARK: Initializing
    
    init(viewModel: ItemListViewModelType) {
        super.init(nibName: nil, bundle: nil)
        configure(viewModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = searchButton
        self.view.addSubview(videoListView)
        setupConstraint()
    }
    
    // MARK: Setup Constraint
    
    private func setupConstraint() {
    }
    
    // MARK: Configuring
    
    private func configure(_ viewModel: ItemListViewModelType) {
        self.rx.viewDidLoad
            .bind(to: viewModel.viewDidLoad)
            .disposed(by: disposeBag)
        
        viewModel.itemDataSource
            .drive(videoListView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        videoListView.delegate = dataSource
        
        dataSource.selectedIndexPath
            .bind(to: viewModel.selectedIndexPath)
            .disposed(by: disposeBag)
    }
    
    class DataSource: NSObject, RxTableViewDataSourceType, UITableViewDataSource, UITableViewDelegate {
        
        typealias Element = SearchItemCellModel
        var items: [SearchItemCellModel.ItemType] = []
        
        fileprivate let selectedIndexPath = PublishRelay<IndexPath>()
        
        func tableView(_ tableView: UITableView, observedEvent: Event<SearchItemCellModel>) {
            if case .next(let model) = observedEvent {
                self.items = model.items
                tableView.reloadData()
            }
        }
        
        // MARK: UITableViewDataSource
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return items.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let item = items[indexPath.row]
            switch item {
            case .video(let video):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchVideoCell.identifier, for: indexPath) as? SearchVideoCell else { fatalError("Could not create Cell") }
                cell.config(model: video)
                return cell
            case .playlist(let playlist):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchPlaylistCell.identifier, for: indexPath) as? SearchPlaylistCell else { fatalError("Could not create Cell") }
                cell.config(model: playlist)
                return cell
            case .channel(let channel):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchChannelCell.identifier, for: indexPath) as? SearchChannelCell else { fatalError("Could not create Cell") }
                cell.config(model: channel)
                return cell
            }
        }
        
        // MARK: UITableViewDelegate
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            selectedIndexPath.accept(indexPath)
        }
        
    }
    
}
