//
//  SearchItems.swift
//  Rx_TubeApp
//
//  Created by 細田　大志 on 2017/07/11.
//  Copyright © 2017 HIroshi Hosoda. All rights reserved.
//

import Foundation

struct SearchItems {
    let items: [Item]
    
    struct Item {
        let id: ItemId
        
        struct ItemId {
            let kind: String
            let videoId: String?
            let channelId: String?
            let playlistId: String?
        }
        
        let snippet: Snippet
        
        struct Snippet {
            let publishedAt: String
            let channelId: String
            let title: String
            let description: String
            let thumbnails: Thumbnails
            let channelTitle: String
            let liveBroadcastContent: String
            
            struct Thumbnails {
                let `default`: Image
                let medium: Image
                let high: Image
                
                struct Image {
                    let url: String
                    let width: Int
                    let height: Int
                }
            }
        }
    }
}
