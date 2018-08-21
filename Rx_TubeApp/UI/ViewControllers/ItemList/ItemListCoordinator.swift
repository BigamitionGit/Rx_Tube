//
//  ItemListCoordinator.swift
//  Rx_TubeApp
//
//  Created by 細田　大志 on 2017/10/14.
//  Copyright © 2017 HIroshi Hosoda. All rights reserved.
//

import UIKit
import RxSwift
import Moya

final class ItemListCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let searchRepository = YoutubeSearchRepository(provider: YoutubeAPI.provider)
        let searchDetailRepository = YoutubeSearchDetailsRepository(provider: YoutubeAPI.provider)
        let viewModel = ItemListViewModel(searchRepository: searchRepository, searchDetailRepository: searchDetailRepository, type: .HD)
        let viewController = ItemListViewController(viewModel: viewModel)
        
        let navigationController = NavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
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
