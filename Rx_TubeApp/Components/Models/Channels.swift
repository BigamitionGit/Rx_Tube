//
//  Channels.swift
//  Rx_TubeApp
//
//  Created by 細田　大志 on 2017/09/03.
//  Copyright © 2017 HIroshi Hosoda. All rights reserved.
//

struct Channels: Codable {
    let items: [Item]
    
    struct Item: Codable {
        let id: String
        let snippet: Snippet?
        let contentDetails: ContentDetails?
        let statistics: Statistics?
        let topicDetails: TopicDetails?
        
        struct Snippet: Codable {
            let title: String
            let description: String
            let publishedAt: String
            let thumbnails: Thumbnails
        }
        
        struct ContentDetails: Codable {
            let relatedPlaylists: RelatedPlaylists
            
            struct RelatedPlaylists: Codable {
                let likes: String
                let favorites: String
                let uploads: String
                let watchHistory: String
                let watchLater: String
            }
        }
        
        struct Statistics: Codable {
            let viewCount: Int
            let commentCount: Int
            let subscriberCount: Int
            let hiddenSubscriberCount: Int
            let videoCount: Int
        }
        
        struct TopicDetails: Codable {
            let topicIds: [String]
        }
    }
}
