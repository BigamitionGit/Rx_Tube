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
    
    var channelDidTap: PublishRelay<SearchItemDetails.Channel> { get }
    
    // Output
    
    var playVideo: Signal<SearchItemDetails.Video> { get }
    
}

final class ChannelViewModel: ChannelViewModelType {
    
    // Input
    
    let channelDidTap = PublishRelay<SearchItemDetails.Channel>()
    
    // Output
    
    let playVideo: Signal<SearchItemDetails.Video>
    
    init(repository: YoutubeChannelsRepositoryType) {
        playVideo = Signal.empty()
    }
    
}
