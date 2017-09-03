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
        
        struct Snippet: Codable {
            let publishedAt: String
            let channelId: String
            let title: String
            let description: String
            let thumbnails: Thumbnails
            let channelTitle: String
            let tags: [String]
            var categoryId: String
            
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
            let duration: String
            let dimension: String
            let definition: String
            let caption: String
        }
        
        struct Statistics: Codable {
            let viewCount: String
            let likeCount: String
            let dislikeCount: String
            let favoriteCount: String
            let commentCount: String
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
