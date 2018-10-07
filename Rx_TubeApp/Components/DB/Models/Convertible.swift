//
//  Convertible.swift
//  Rx_TubeApp
//
//  Created by 細田大志 on 2018/10/07.
//  Copyright © 2018 HIroshi Hosoda. All rights reserved.
//

import Foundation
import RealmSwift

protocol ConvertibleToRealmObject {
    
    associatedtype T: Object
    
    func toRealmObject() -> T
}

protocol ConvertibleToModel {
    
    associatedtype T
    
    func toModel() -> T
}
