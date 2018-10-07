//
//  Database.swift
//  Rx_TubeApp
//
//  Created by 細田大志 on 2018/10/07.
//  Copyright © 2018 HIroshi Hosoda. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift



final class Database {
    
    static let shared = Database()
    
    private init() {}
    
    func config() {
        var realmConfig = Realm.Configuration()
        realmConfig.fileURL = realmConfig.fileURL?.deletingLastPathComponent().appendingPathComponent("RxTube.realm")
        Realm.Configuration.defaultConfiguration = realmConfig
    }
    
    func fetch(): Maybe<U> {
        
    }
}
