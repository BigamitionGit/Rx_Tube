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
        
        struct Snippet: Codable {
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
    
    let searchItemId: String
    let kind: Kind
    
    enum Kind {
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
            searchItemId = id
            kind = .video
        } else if let id = try? values.decode(String.self, forKey: .channelId) {
            searchItemId = id
            kind = .channel
        } else if let id = try? values.decode(String.self, forKey: .playlistId) {
            searchItemId = id
            kind = .playlist
        } else {
            throw SearchItemIdCodingError.decoding("Decoding Error")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self.kind {
        case .video:
            try container.encode(self.searchItemId, forKey: .videoId)
        case .channel:
            try container.encode(self.searchItemId, forKey: .channelId)
        case .playlist:
            try container.encode(self.searchItemId, forKey: .playlistId)
        }
    }
}
