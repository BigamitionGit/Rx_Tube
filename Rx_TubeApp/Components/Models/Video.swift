//
//  Video.swift
//  Rx_TubeApp
//
//  Created by 細田　大志 on 2017/07/06.
//  Copyright © 2017 HIroshi Hosoda. All rights reserved.
//

import Foundation
import UIKit

struct Video {
    let publishedAt: String
    let channelId: String
    let title: String
    let description: String
    let thumbnails: Thumbnails
    let channelTitle: String
    let tags: [String]
    var categoryId: String
    
    struct Thumbnails {
        struct Image {
            let url: String
            let width: Int
            let height: Int
        }
        
        let `default`: Image
        let medium: Image
        let high: Image
        let standard: Image
    }
}

struct Channel {
    
}
