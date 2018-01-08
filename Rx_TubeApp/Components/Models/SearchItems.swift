//
//  SearchItems.swift
//  Rx_TubeApp
//
//  Created by 細田　大志 on 2017/07/11.
//  Copyright © 2017 HIroshi Hosoda. All rights reserved.
//

import Foundation

struct SearchItems: Codable {
    let items: [Item]
    
    struct Item: Codable {
        let id: SearchItemId
        let snippet: Snippet
            
        struct Snippet: Codable, ContentsSnippetType {
            let publishedAt: String
            let channelId: String
            let title: String
            let description: String
            let thumbnails: Thumbnails
            let channelTitle: String
            let liveBroadcastContent: String
        }
    }
}

struct SearchItemId: Codable {
    
    enum SearchItemType {
        case video
        case channel
        case playlist
    }
}

extension SearchItemId {
    private enum CodingKeys: String, CodingKey {
        case videoId
        case channelId
        case playlistId
    }
    
    enum SearchItemIdCodingError: Error {
        case decoding(String)
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let id = try? values.decode(String.self, forKey: .videoId) {
            self = .video(id: id)
        } else if let id = try? values.decode(String.self, forKey: .channelId) {
            self = .channel(id: id)
        } else if let id = try? values.decode(String.self, forKey: .playlistId) {
            self = .playlist(id: id)
        } else {
            throw SearchItemIdCodingError.decoding("Decoding Error")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .video(let id):
            try container.encode(id, forKey: .videoId)
        case .channel(let id):
            try container.encode(id, forKey: .channelId)
        case .playlist(let id):
            try container.encode(id, forKey: .playlistId)
        }
    }
}
