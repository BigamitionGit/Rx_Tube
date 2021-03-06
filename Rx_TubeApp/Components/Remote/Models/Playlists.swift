//
//  Playlists.swift
//  Rx_TubeApp
//
//  Created by 細田　大志 on 2017/09/03.
//  Copyright © 2017 HIroshi Hosoda. All rights reserved.
//

struct Playlists: Codable {
    
    let items: [Item]
    
    struct Item: Codable {
        let id: String
        let snippet: Snippet?
        let contentDetails: ContentDetails?
        let player: Player?
        
        struct Snippet: Codable {
            let title: String
            let description: String
            let publishedAt: String
            let thumbnails: Thumbnails
            let channelId: String
            let tags: [String]
            var channelTitle: String
        }
        
        struct ContentDetails: Codable {
            let itemCount: Int
        }
        
        struct Player: Codable {
            let embedHtml: String
        }
    }
}
