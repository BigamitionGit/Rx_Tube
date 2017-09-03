//
//  Channels.swift
//  Rx_TubeApp
//
//  Created by 細田　大志 on 2017/09/03.
//  Copyright © 2017 HIroshi Hosoda. All rights reserved.
//

struct Channels {
    let items: [Item]
    
    struct Item {
        struct Snippet {
            let title: String
            let description: String
            let publishedAt: String
            let thumbnails: Thumbnails
            
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
        
        struct ContentDetails {
            let relatedPlaylists: RelatedPlaylists
            
            struct RelatedPlaylists {
                let likes: String
                let favorites: String
                let uploads: String
                let watchHistory: String
                let watchLater: String
            }
        }
        
        struct Statistics {
            let viewCount: Int
            let commentCount: Int
            let subscriberCount: Int
            let hiddenSubscriberCount: Int
            let videoCount: Int
        }
        
        struct topicDetails {
            let topicIds: [String]
        }
    }
}
