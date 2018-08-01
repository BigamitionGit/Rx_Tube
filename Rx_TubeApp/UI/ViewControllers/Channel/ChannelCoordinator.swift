//
//  ChannelCoordinator.swift
//  Rx_TubeApp
//
//  Created by 細田　大志 on 2017/10/26.
//  Copyright © 2017 HIroshi Hosoda. All rights reserved.
//

import UIKit
import RxSwift
import RxMoya

enum ChannelCoordinationResult {
    case search
    case player(id: String)
}

final class ChannelCoordinator: BaseCoordinator<ChannelCoordinationResult> {

    private let channelId: String
    private let rootViewController: UIViewController
    
    init(channelId: String, rootViewController: UIViewController) {
    
        self.channelId = channelId
        self.rootViewController = rootViewController
    }
    
    override func start() -> Observable<CoordinationResult> {
        let repository = YoutubeChannelsRepository(provider: YoutubeAPI.provider)
        let viewModel = ChannelViewModel(channelId: channelId, repository: repository)
        let viewController = ChannelViewController(viewModel: viewModel)
        
        rootViewController.navigationController?.pushViewController(viewController, animated: true)
        
        return Observable.never()
    }
}
