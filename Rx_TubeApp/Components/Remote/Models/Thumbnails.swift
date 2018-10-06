//
//  Thumbnails.swift
//  Rx_TubeApp
//
//  Created by 細田　大志 on 2017/09/21.
//  Copyright © 2017 HIroshi Hosoda. All rights reserved.
//

struct Thumbnails: Codable {
    let `default`: Image
    let medium: Image
    let high: Image
    let standard: Image
    
    struct Image: Codable {
        let url: String
        let width: Int
        let height: Int
    }
}
