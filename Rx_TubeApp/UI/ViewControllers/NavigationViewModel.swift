//
//  NavigationViewModel.swift
//  Rx_TubeApp
//
//  Created by 細田大志 on 2018/08/08.
//  Copyright © 2018年 HIroshi Hosoda. All rights reserved.
//

import RxCocoa
import RxSwift

protocol NavigationViewModelType {
    // Input
    
    var videoDidTap: PublishRelay<Void> { get }
    
    // Output

}

final class NavigationViewModel: NavigationViewModelType {
    
    // Input
    
    let videoDidTap = PublishRelay<Void>()
    
    init() {
    }
    
}

