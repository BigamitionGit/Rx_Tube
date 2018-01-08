//
//  AppCoordinator.swift
//  Rx_TubeApp
//
//  Created by 細田　大志 on 2017/10/14.
//  Copyright © 2017 HIroshi Hosoda. All rights reserved.
//

import UIKit
import RxSwift

final class AppCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let itemListCoordinator = ItemListCoordinator(window: window)
        return coordinate(to: itemListCoordinator)
    }
}

