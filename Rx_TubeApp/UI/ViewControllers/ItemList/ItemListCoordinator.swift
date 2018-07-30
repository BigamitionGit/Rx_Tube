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
        self.provider = YoutubeAPI.provider
    }
    
    override func start() -> Observable<Void> {
        let repository = YoutubeSearchRepository(provider: provider)
        let viewModel = ItemListViewModel(repository: repository, type: .HD)
        let viewController = ItemListViewController(viewModel: viewModel)
        
        window.rootViewController = NavigationController(rootViewController: viewController)
        window.makeKeyAndVisible()
        
        return Observable.never()
    }
}
