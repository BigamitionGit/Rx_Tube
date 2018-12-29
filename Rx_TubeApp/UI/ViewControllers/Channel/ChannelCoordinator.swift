//
//  ChannelCoordinator.swift
//  Rx_TubeApp
//
//  Created by 細田　大志 on 2017/10/26.
//  Copyright © 2017 HIroshi Hosoda. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxMoya

enum ChannelCoordinationResult {
    case player(video: SearchItemDetails.Video)
}

final class ChannelCoordinator: BaseCoordinator<ChannelCoordinationResult> {
    
    private let channel: Signal<SearchItemDetails.Channel>
    private let rootViewController: UIViewController
    
    init(channel: Signal<SearchItemDetails.Channel>, rootViewController: UIViewController) {
        
        self.channel = channel
        self.rootViewController = rootViewController
    }
    
    override func start() -> Observable<CoordinationResult> {
        let youtubeChannelsRepository = YoutubeChannelsRepository(provider: YoutubeAPI.provider)
        let channelViewModel = ChannelViewModel(repository: youtubeChannelsRepository)
        let viewController = ChannelViewController(viewModel: channelViewModel)
        
        channel
            .emit(to: channelViewModel.channelDidTap)
            .disposed(by: disposeBag)
        
        rootViewController.navigationController?.pushViewController(viewController, animated: true)
        
        return channelViewModel.playVideo
            .map { ChannelCoordinationResult.player(video: $0) }
            .asObservable()
    }
}
