//
//  NavigationController.swift
//  Rx_TubeApp
//
//  Created by 細田　大志 on 2017/10/28.
//  Copyright © 2017 HIroshi Hosoda. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NavigationController: UINavigationController {
    
    let videoDidTap = PublishRelay<PlayerViewModelType>()
        
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
    }
    
    
}
