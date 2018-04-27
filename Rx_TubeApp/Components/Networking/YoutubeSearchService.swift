//
//  YoutubeSearchService.swift
//  Rx_TubeApp
//
//  Created by 細田大志 on 2018/03/08.
//  Copyright © 2018年 HIroshi Hosoda. All rights reserved.
//

import RxSwift
import RxMoya
import Moya

protocol YoutubeSearchServiceType {
    
}

final class YoutubeSearchService: YoutubeSearchServiceType {
    
    init(action: Observable<YoutubeSearchEvent>) {
        
    }
    
}


struct StateMachine<S: StateType, E: EventType, T: TransitionType> {
    let s: Observable<(S, T.B)>
    
    init(event: Observable<E>, transitions: Set<T>) {
        
    }
    
}

struct YoutubeSearchEvent: EventType {
    
}

struct YoutubeSearchState: StateType {
    
}

protocol EventType {}

protocol StateType {}

protocol TransitionType {
    associatedtype B
    associatedtype S: StateType
    associatedtype E: EventType
    
    func transition(state: S, event: E)->(S, B)
}

