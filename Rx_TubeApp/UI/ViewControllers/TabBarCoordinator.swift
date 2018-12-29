//
//  TabBarCoordinator.swift
//  Rx_TubeApp
//
//  Created by 細田大志 on 2018/10/31.
//  Copyright © 2018 HIroshi Hosoda. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class TabBarCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        
        // TabBarController
        let tabBarController = TabBarController()
        let tabBarViewModel = TabBarViewModel()
        
        // Player
        let relatedVideoRepository = YoutubeRelatedVideosRepository(provider: YoutubeAPI.provider)
        let playerViewModel = PlayerViewModel(relatedVideoRepository: relatedVideoRepository)
        
        tabBarController.inject(tabBarViewModel: tabBarViewModel,
                                playerViewModel: playerViewModel)
        
        // ItemList
        let searchRepository = YoutubeSearchRepository(provider: YoutubeAPI.provider)
        let searchDetailRepository = YoutubeSearchDetailsRepository(provider: YoutubeAPI.provider)
        let itemListViewModel = ItemListViewModel(
            searchRepository: searchRepository,
            searchDetailRepository: searchDetailRepository,
            itemListDataSourceTranslator: ItemListDataSourceTranslator())
        let itemListViewController = ItemListViewController(viewModel: itemListViewModel)
        let navigationController = NavigationController(rootViewController: itemListViewController)
        
        
        let channel = Signal
            .of(playerViewModel.showChannelDetail, itemListViewModel.showChannelDetail)
            .merge()
        let playVideo = ChannelCoordinator(channel: channel, rootViewController: tabBarController)
        
        itemListViewModel.playVideo
            .emit(to: playerViewModel.videoDidTap)
            .disposed(by: disposeBag)
        
        itemListViewModel.showPlayer
            .emit(to: tabBarViewModel.videoDidTap)
            .disposed(by: disposeBag)
        
        // Home
        let homeViewModel = HomeViewModel()
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        
        tabBarController.setViewControllers([homeViewController, navigationController], animated: true)
        
        viewModel.showPlayer
            .map { video in PlayerCoordinator(navigationController: navigationController, video: video) }
            .flatMap { coordinator in coordinator.start() }
            .subscribe(onNext: { playerResult in
                switch playerResult {
                case .channel(let channel):
                    viewModel.pushChannelDetail.accept(channel)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.pushChannelDetail.map { channel in ChannelCoordinator(channel: channel, rootViewController: viewController) }
            .flatMap { coordinator in coordinator.start() }
            .subscribe(onNext: { channelDetailResult in
                switch channelDetailResult {
                case .player(let video):
                    viewModel.showPlayer.accept(video)
                }
            })
            .disposed(by: disposeBag)
        
        return Observable.never()
    }
}

