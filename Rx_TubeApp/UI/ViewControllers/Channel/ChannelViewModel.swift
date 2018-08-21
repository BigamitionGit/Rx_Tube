//
//  ChannelViewModel.swift
//  Rx_TubeApp
//
//  Created by 細田　大志 on 2017/10/06.
//  Copyright © 2017 HIroshi Hosoda. All rights reserved.
//

import RxCocoa
import RxSwift

protocol ChannelViewModelType {
    // Input
    
    var viewDidLoad: PublishSubject<Void> { get }
    var videoDidTap: PublishSubject<Int> { get }
    
    // Output
    
    var showPlayer: Driver<String> { get }
}

final class ChannelViewModel: ChannelViewModelType {
    
    // Input
    
    let viewDidLoad = PublishSubject<Void>()
    let videoDidTap = PublishSubject<Int>()
    
    let showPlayer: Driver<String>
    
    init(channel: SearchItemDetails.Channel, repository: YoutubeChannelsRepositoryType) {
        showPlayer = Driver.empty()
    }
    
}
