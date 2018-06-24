//
//  StateMachine.swift
//  Rx_TubeApp
//
//  Created by 細田大志 on 2018/06/20.
//  Copyright © 2018年 HIroshi Hosoda. All rights reserved.
//

import RxCocoa
import RxSwift

struct StateMachine<State, Event, Effect> {
    private let state: BehaviorRelay<State>
    let effect = PublishRelay<Effect>()
    
    private var _disposeBag = DisposeBag()
    
    typealias Mapping = (Event, State) -> State
    typealias EffectMapping = (Event, State) -> Effect
    
    init(initial state: State, event: PublishRelay<Event>, mapping: @escaping Mapping, effectMapping: @escaping EffectMapping) {
        
        self.state = BehaviorRelay<State>(value: state)
        event
            .withLatestFrom(self.state, resultSelector: mapping)
            .bind(to: self.state)
            .disposed(by: _disposeBag)
        
        event
            .withLatestFrom(self.state, resultSelector: effectMapping)
            .bind(to: effect)
            .disposed(by: _disposeBag)
    }
    
}
