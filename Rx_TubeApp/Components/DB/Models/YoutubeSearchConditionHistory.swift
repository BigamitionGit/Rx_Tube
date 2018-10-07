//
//  YoutubeSearchConditionHistory.swift
//  Rx_TubeApp
//
//  Created by 細田大志 on 2018/10/07.
//  Copyright © 2018 HIroshi Hosoda. All rights reserved.
//

import Foundation
import RealmSwift

final class YoutubeSearchConditionHistoryRealmObject: Object, ConvertibleToModel {
    
    @objc dynamic var userId: String = ""
    var history: List<YoutubeSearchConditionRealmObject> = List()
    
    override static func primaryKey() -> String? {
        return "userId"
    }
    
    func toModel() -> YoutubeSearchConditionHistory {
        return YoutubeSearchConditionHistory(userId: userId, history: Array(history.map { $0.toModel() }))
    }
}

struct YoutubeSearchConditionHistory: ConvertibleToRealmObject {
    
    let userId: String
    let history: [YoutubeSearchCondition]
    
    func toRealmObject() -> YoutubeSearchConditionHistoryRealmObject {
        let realmObject = YoutubeSearchConditionHistoryRealmObject()
        realmObject.userId = userId
        realmObject.history = List(history.map { $0.toRealmObject() })
        return realmObject
    }
}
