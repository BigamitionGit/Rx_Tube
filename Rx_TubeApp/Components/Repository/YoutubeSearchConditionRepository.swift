//
//  YoutubeSearchConditionRepository.swift
//  Rx_TubeApp
//
//  Created by 細田大志 on 2018/10/14.
//  Copyright © 2018 HIroshi Hosoda. All rights reserved.
//

import Foundation
import RxSwift

protocol YoutubeSearchConditionRepositoryType {
    
    func fetch() -> Maybe<YoutubeSearchConditionHistory>
    
    func store(model: YoutubeSearchCondition) -> Completable
    
    func delete() -> Completable
    
    func deleteAll() -> Completable
}

final class YoutubeSearchConditionRepository: YoutubeSearchConditionRepositoryType {
    
    private let database: Database
    
    init(database: Database) {
        self.database = database
    }
    
    func fetch() -> Maybe<YoutubeSearchConditionHistory> {
        // Todo: DI get userId
        let userId = ""
        return database.fetchByPrimaryKey(type: YoutubeSearchConditionHistoryRealmObject.self, primaryKey: userId)
    }
    
    func store(model: YoutubeSearchCondition) -> Completable {
        // Todo: DI get userId
        let userId = ""
        return database.fetchByPrimaryKey(type: YoutubeSearchConditionHistoryRealmObject.self, primaryKey: userId)
            .map { YoutubeSearchConditionHistory(userId: userId, history: $0.history + [model]) }
            .ifEmpty(default: YoutubeSearchConditionHistory(userId: userId, history: [model]))
            .flatMapCompletable(database.store)
    }
    
    func delete() -> Completable {
        // Todo: DI get userId
        let userId = ""
        return database.deleteByPrimaryKey(type: YoutubeSearchConditionHistoryRealmObject.self, primaryKey: userId)
    }
    
    func deleteAll() -> Completable {
        return database.deleteAll(type: YoutubeSearchConditionHistoryRealmObject.self)
    }
}
