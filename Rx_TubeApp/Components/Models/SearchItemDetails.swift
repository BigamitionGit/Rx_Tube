//
//  SearchItemDetails.swift
//  Rx_TubeApp
//
//  Created by 細田大志 on 2018/06/21.
//  Copyright © 2018年 HIroshi Hosoda. All rights reserved.
//

import Foundation

struct SearchItemDetails {
    
    let items: [ItemType]
    
    enum ItemType {
        case video(video: Videos.Item, channel: Channels.Item)
        case channel(channel: Channels.Item)
        case playlist(playlist: Playlists.Item, channel: Channels.Item)
        
        var video: (Videos.Item, Channels.Item)? {
            switch self {
            case .video(let v): return v
            case .channel, .playlist: return nil
            }
        }
        
        var channel: Channels.Item? {
            switch self {
            case .channel(let c): return c
            case .video, .playlist: return nil
            }
        }
        
        var playlist: (Playlists.Item, Channels.Item)? {
            switch self {
            case .playlist(let p): return p
            case .video, .channel: return nil
            }
        }
    }
}
