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
    
    var playerView: PlayerView?
    
    let disposeBag = DisposeBag()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        
        playerView?.viewModel.showChannelDetail
            .subscribe(onNext: { [weak self] _ in self?.dismissPlayer() })
            .disposed(by: disposeBag)
    }
    
    func showPlayer() {
        
    }
    
    func dismissPlayer() {
        
    }
}
