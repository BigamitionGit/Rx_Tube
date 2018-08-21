//
//  PlayerCoordinator.swift
//  Rx_TubeApp
//
//  Created by 細田大志 on 2018/08/08.
//  Copyright © 2018年 HIroshi Hosoda. All rights reserved.
//

import RxSwift

enum PlayerCoordinatorResult {
    case channel(SearchItemDetails.Channel)
}

final class PlayerCoordinator: BaseCoordinator<PlayerCoordinatorResult> {
    
    private let navigationController: NavigationController
    private let video: SearchItemDetails.Video
    
    init(navigationController: NavigationController, video: SearchItemDetails.Video) {
        self.navigationController = navigationController
        self.video = video
    }
    
    override func start() -> Observable<PlayerCoordinatorResult> {
        
        let getPlayerView: () -> PlayerView = { [weak self] in
            if let playerView = self?.navigationController.playerView {
                return playerView
            } else {
                let playerViewModel = PlayerViewModel(relatedVideoRepository: YoutubeRelatedVideosRepository(provider: YoutubeAPI.provider))
                let playerview = PlayerView(viewModel: playerViewModel)
                self?.navigationController.playerView = playerview
                return playerview
            }
        }
        
        let playerViewModel = getPlayerView().viewModel
        playerViewModel.videoDidTap.accept(video)
        navigationController.showPlayer()
        
        return playerViewModel.showChannelDetail
            .map(PlayerCoordinatorResult.channel)
    }
}
