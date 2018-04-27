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
    private let provider: MoyaProvider<YoutubeAPI>
    
    init(window: UIWindow) {
        self.window = window
        self.provider = YoutubeProvider
    }
    
    override func start() -> Observable<Void> {
        let service = YoutubeService(provider: provider)
        let viewModel = ItemListViewModel(service: service, type: .HD)
        let viewController = ItemListViewController(viewModel: viewModel)
        
        let navigationController = NavigationController(rootViewController: viewController)
        
        
        
        viewModel.pushChannelDetail.flatMap { [weak self] channelId in
            
        }
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return Observable.never()
    }
}
