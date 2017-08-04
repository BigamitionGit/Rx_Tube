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
}

struct Item: Codable {
    let id: ItemId
    
    let snippet: Snippet
}

struct ItemId: Codable {
    let kind: String
    let videoId: String?
    let channelId: String?
    let playlistId: String?
}

struct Snippet: Codable {
    let publishedAt: String
    let channelId: String
    let title: String
    let description: String
    let thumbnails: Thumbnails
    let channelTitle: String
    let liveBroadcastContent: String
}

struct Thumbnails: Codable {
    let `default`: Image
    let medium: Image
    let high: Image
}

struct Image: Codable {
    let url: String
    let width: Int
    let height: Int
}
