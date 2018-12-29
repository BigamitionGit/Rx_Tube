//
//  TabBarViewModel.swift
//  Rx_TubeApp
//
//  Created by 細田大志 on 2018/10/31.
//  Copyright © 2018 HIroshi Hosoda. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol TabBarViewModelType {
    
    /// Input
    var videoDidTap: PublishRelay<Void> { get }
    var playerDidTap: PublishRelay<Void> { get }
    
    /// Output
    var showPlayer: Signal<Void> { get }
}

final class TabBarViewModel: TabBarViewModelType {
    
    /// Input
    let videoDidTap = PublishRelay<Void>()
    let playerDidTap = PublishRelay<Void>()
    
    /// Output
    let showPlayer: Signal<Void>
    
    init() {
        showPlayer = Signal
            .of(
                videoDidTap.asSignal(),
                playerDidTap.asSignal())
            .merge()
    }
}
