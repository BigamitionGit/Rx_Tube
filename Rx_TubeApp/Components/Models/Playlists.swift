//
//  Playlists.swift
//  Rx_TubeApp
//
//  Created by 細田　大志 on 2017/09/03.
//  Copyright © 2017 HIroshi Hosoda. All rights reserved.
//

struct Playlists: Codable {
    let id: String
    let snippet: Snippet
    let contentDetails: ContentDetails
    let player: Player
    
    struct Snippet: Codable {
        let title: String
        let description: String
        let publishedAt: String
        let thumbnails: Thumbnails
        let channelId: String
        let tags: [String]
        var channelTitle: String
        
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
    }
    
    struct ContentDetails: Codable {
        let itemCount: Int
    }
    
    struct Player: Codable {
        let embedHtml: String
    }
}
