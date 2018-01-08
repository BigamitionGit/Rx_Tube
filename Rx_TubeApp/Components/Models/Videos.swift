//
//  Videos.swift
//  Rx_TubeApp
//
//  Created by 細田　大志 on 2017/09/03.
//  Copyright © 2017 HIroshi Hosoda. All rights reserved.
//

struct Videos: Codable {
    
    let items: [Item]
    
    struct Item: Codable {
        let id: String
        let snippet: Snippet?
        let contentDetails: ContentDetails?
        let statistics: Statistics?
        let player: Player?
        let topicDetails: TopicDetails?
        let recordingDetails: RecordingDetails?
        
        struct Snippet: Codable, ContentsSnippetType {
            let publishedAt: String
            let channelId: String
            let title: String
            let description: String
            let thumbnails: Thumbnails
            let channelTitle: String
            let tags: [String]
            var categoryId: String
        }
        
        struct ContentDetails: Codable {
            
            enum Definition: String {
                case hd
                case sd
            }
            
            let duration: String
            let dimension: String
            let definition: String
            let caption: String
        }
        
        struct Statistics: Codable {
            let viewCount: Int
            let likeCount: Int
            let dislikeCount: Int
            let favoriteCount: Int
            let commentCount: Int
        }
        
        struct Player: Codable {
            let embedHtml: String
        }
        
        struct TopicDetails: Codable {
            let relevantTopicIds: [String]
            let topicCAtegories: [String]
        }
        
        struct RecordingDetails: Codable {
            let locationDescription: String
            let location: Location
            let recordingDate: String
            
            struct Location: Codable {
                let latitude: Double
                let longitude: Double
                let altitude: Double
            }
        }
        
    }
}
