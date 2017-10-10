//
//  ObservableType+Codable.swift
//  Rx_TubeApp
//
//  Created by 細田　大志 on 2017/10/05.
//  Copyright © 2017 HIroshi Hosoda. All rights reserved.
//

import Foundation
import RxSwift
import Moya

extension ObservableType where E == Data {
    public func map<T>(_ type: T.Type, using decoder: JSONDecoder? = nil) -> Observable<T> where T: Decodable {
        return self.map { data -> T in
            let decoder = decoder ?? JSONDecoder()
            return try decoder.decode(type, from: data)
        }
    }
}

extension ObservableType where E == String {
    public func map<T>(_ type: T.Type, using decoder: JSONDecoder? = nil) -> Observable<T> where T: Decodable {
        return self
            .map { string in string.data(using: .utf8) ?? Data() }
            .map(type, using: decoder)
    }
}

extension ObservableType where E == Moya.Response {
    public func map<T>(_ type: T.Type, using decoder: JSONDecoder? = nil) -> Observable<T> where T: Decodable {
        return self
            .map { response in response.data }
            .map(type, using: decoder)
    }
}
