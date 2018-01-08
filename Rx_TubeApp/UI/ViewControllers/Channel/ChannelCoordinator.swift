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
    private let service: YoutubeServiceType
    private let rootViewController: UIViewController
    
    init(channelId: String, service: YoutubeServiceType, rootViewController: UIViewController) {
    
        self.channelId = channelId
        self.service = service
        self.rootViewController = rootViewController
    }
    
    override func start() -> Observable<CoordinationResult> {
        let viewModel = ChannelViewModel(channelId: channelId, service: service)
        let viewController = ChannelViewController(viewModel: viewModel)
        
        rootViewController.navigationController?.pushViewController(viewController, animated: true)
        
        return Observable.never()
    }
}
