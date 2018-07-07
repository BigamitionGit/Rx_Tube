//
//  NavigationController.swift
//  Rx_TubeApp
//
//  Created by 細田　大志 on 2017/10/28.
//  Copyright © 2017 HIroshi Hosoda. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NavigationController: UINavigationController {
    
    let showPlayer = PublishSubject<String>()
    let showSearchView = PublishSubject<Void>()
    
    fileprivate let searchViewModel = SearchViewModel(repository: YoutubeSearchRepository(provider: YoutubeProvider))
    fileprivate let playerViewModel = PlayerViewModel(videoRepository: YoutubeVideosRepository(provider: YoutubeProvider))
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        // SearchView
        let searchView = SearchView(viewModel: searchViewModel)
        self.view.addSubview(searchView)
        
        // PlayerView
        let playerView = PlayerView(viewModel: playerViewModel)
        self.view.addSubview(playerView)
        
        // NavigationBar buttons
        
        let searchButton = UIButton()
        self.navigationBar.addSubview(searchButton)
    }
}

extension Reactive where Base: NavigationController {

    var performSearch: Driver<[SearchViewModel.Option]> {
        return base.searchViewModel.search
    }
    
    var showChannelDetail: Driver<String> {
        return base.playerViewModel.showChannelDetail
    }
}
