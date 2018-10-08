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
    
    associatedtype O: Object
    
    func toRealmObject() -> O
}

protocol ConvertibleToModel {
    
    associatedtype M
    
    func toModel() -> M
}
