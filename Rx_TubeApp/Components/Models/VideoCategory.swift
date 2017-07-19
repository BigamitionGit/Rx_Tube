//
//  VideoCategory.swift
//  Rx_TubeApp
//
//  Created by 細田　大志 on 2017/07/17.
//  Copyright © 2017 HIroshi Hosoda. All rights reserved.
//

import Foundation

struct VideoCategory {
    let id: String
    let snippet: Snippet
    
    struct Snippet {
        let channelId: String
        let title: String
        let assignable: Bool
    }
}
