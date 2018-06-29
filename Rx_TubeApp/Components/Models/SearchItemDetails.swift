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
        case video(Video)
        case channel(Channel)
        case playlist(Playlist)
        
        var video: Video? {
            switch self {
            case .video(let v): return v
            case .channel, .playlist: return nil
            }
        }
        
        var channel: Channel? {
            switch self {
            case .channel(let c): return c
            case .video, .playlist: return nil
            }
        }
        
        var playlist: Playlist? {
            switch self {
            case .playlist(let p): return p
            case .video, .channel: return nil
            }
        }
    }
    
    struct Video {
        let id: String
        let snippet: Videos.Item.Snippet
        let contentDetails: Videos.Item.ContentDetails
        let statistics: Videos.Item.Statistics
        let player: Videos.Item.Player
        let channelId: String
        let channelSnippet: Channels.Item.Snippet
        let channelContentDetails: Channels.Item.ContentDetails
        let channelStatistics: Channels.Item.Statistics
        let channelTopicDetails: Channels.Item.TopicDetails
        
        init?(video: Videos.Item, channel: Channels.Item) {
            guard let snippet = video.snippet,
                let contentDetails = video.contentDetails,
                let statistics = video.statistics,
                let player = video.player,
                let channelSnippet = channel.snippet,
                let channelContentDetails = channel.contentDetails,
                let channelStatistics = channel.statistics,
                let channelTopicDetails = channel.topicDetails else { return nil }
            
            self.id = video.id
            self.snippet = snippet
            self.contentDetails = contentDetails
            self.statistics = statistics
            self.player = player
            self.channelId = channel.id
            self.channelSnippet = channelSnippet
            self.channelContentDetails = channelContentDetails
            self.channelStatistics = channelStatistics
            self.channelTopicDetails = channelTopicDetails
        }
    }
    
    struct Channel {
        let id: String
        let snippet: Channels.Item.Snippet
        let contentDetails: Channels.Item.ContentDetails
        let statistics: Channels.Item.Statistics
        let topicDetails: Channels.Item.TopicDetails
        
        init?(channel: Channels.Item) {
            guard let snippet = channel.snippet,
                let contentDetails = channel.contentDetails,
                let statistics = channel.statistics,
                let topicDetails = channel.topicDetails else { return nil }
            
            self.id = channel.id
            self.snippet = snippet
            self.contentDetails = contentDetails
            self.statistics = statistics
            self.topicDetails = topicDetails
        }
    }
    
    struct Playlist {
        let id: String
        let snippet: Playlists.Item.Snippet
        let contentDetails: Playlists.Item.ContentDetails
        let player: Playlists.Item.Player
        let channelId: String
        let channelSnippet: Channels.Item.Snippet
        let channelContentDetails: Channels.Item.ContentDetails
        let channelStatistics: Channels.Item.Statistics
        let channelTopicDetails: Channels.Item.TopicDetails
        
        init?(playlist: Playlists.Item, channel: Channels.Item) {
            guard let snippet = playlist.snippet,
                let contentDetails = playlist.contentDetails,
                let player = playlist.player,
                let channelSnippet = channel.snippet,
                let channelContentDetails = channel.contentDetails,
                let channelStatistics = channel.statistics,
                let channelTopicDetails = channel.topicDetails else { return nil }
            
            self.id = playlist.id
            self.snippet = snippet
            self.contentDetails = contentDetails
            self.player = player
            self.channelId = channel.id
            self.channelSnippet = channelSnippet
            self.channelContentDetails = channelContentDetails
            self.channelStatistics = channelStatistics
            self.channelTopicDetails = channelTopicDetails
        }
    }
}
