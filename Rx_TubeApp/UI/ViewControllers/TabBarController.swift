//
//  TabBarController.swift
//  Rx_TubeApp
//
//  Created by 細田大志 on 2018/10/31.
//  Copyright © 2018 HIroshi Hosoda. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class TabBarController: UITabBarController {
    
    private let disposeBag = DisposeBag()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func inject(tabBarViewModel: TabBarViewModelType,
                playerViewModel: PlayerViewModelType) {
        
        // TODO: setup PlayerView(init, add)
        
        tabBarViewModel.showPlayer
            .emit(onNext: {
                // TODO: show playerview
            })
            .disposed(by: disposeBag)
    }
}
