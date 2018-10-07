//
//  YoutubeAPI.swift
//  Rx_TubeApp
//
//  Created by 細田　大志 on 2017/07/01.
//  Copyright © 2017 HIroshi Hosoda. All rights reserved.
//

import Foundation
import Moya
import RxMoya

private extension String {
    var URLEscapedString: String? {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    }
}

protocol ParameterType {
    var parameter: String { get }
}

extension ParameterType {
    var parameter: String {
        let keyString = String(describing: self)
        guard let index = keyString.index(of: "(") else { return keyString }
        return String(keyString[..<index])
    }
}

enum YoutubeAPI {
    case search(require: RequireParameter.Search, filter: FilterParameter.Search?, option:Set<OptionParameter.Search>)
    case subscriptionsList(require: RequireParameter.Subscriptions, filter:FilterParameter.SubscriptionsList)
    case subscriptionsInsert(require: RequireParameter.Subscriptions, filter:FilterParameter.SubscriptionsInsert)
    case subscriptionsDelete(require: RequireParameter.Delete, filter:FilterParameter.SubscriptionsDelete)
    case channels(require: RequireParameter.Channels, filter:FilterParameter.Channels)
    case videos(require: RequireParameter.Videos, filter:FilterParameter.Videos)
    case playlists(require: RequireParameter.Playlists, filter:FilterParameter.Playlists)
    case videoCategories(require: RequireParameter.VideoCategory, filter:OptionParameter.RegionCode)
    
    static let keyParameter = "key"
    static let keyProperty = "AIzaSyCFCOuvjqfco2AqdsD5WrG21ZcYAoyWyBw"
    
    static let provider = MoyaProvider<YoutubeAPI>()
    
    // MARK: RequireParameter
    
    struct RequireParameter {
        private struct Const {
            static let part = "part"
            static let id = "id"
        }
        
        struct Search {
            let parameter: String = Const.part
            let properties: Set<Property>
            
            enum Property: String {
                case snippet
                case id
            }
        }
        
        struct Subscriptions {
            let parameter: String = Const.part
            let properties: Set<Property>
            
            enum Property: String {
                case snippet
                case id
                case contentDetails
            }
        }
        
        struct Delete {
            let parameter: String = Const.id
            var property: String // Specify the YouTube subscription channel ID.
        }
        
        struct Channels {
            let parameter: String = Const.part
            let properties: Set<Property>
            
            enum Property: String {
                case snippet
                case id
                case contentDetails
                case statistics
                case topicDetails
            }
        }
        
        struct Videos {
            let parameter: String = Const.part
            let properties: Set<Property>
            enum Property: String {
                case snippet
                case id
                case contentDetails
                case player
                case recordingDetails
                case statistics
                case topicDetails
            }
        }
        
        struct VideoCategory {
            let parameter: String = Const.part
            let properties: Set<Property>
            enum Property: String {
                case snippet
                case id
            }
        }
        struct Playlists {
            let parameter: String = Const.part
            let properties: Set<Property>
            
            enum Property: String {
                case snippet
                case id
                case contentDetails
                case player
            }
        }
    }
    
    // MARK: Filter Parameter
    
    struct FilterParameter {
        private struct Const {
            static let regionCode = "regionCode"
            static let channelId = "channelId"
            static let id = "id"
            static let mostPopular = "mostPopular"
        }
        
        enum Search: ParameterType {
            case forContentOwner(Bool)
            case forMine(Bool)
            case relatedToVideoId(id: String)
            
            var property: Any {
                switch self {
                case .forContentOwner(let isContentOwner): return isContentOwner
                case .forMine(let isMine): return isMine
                case .relatedToVideoId(let id): return id
                }
            }
            
            var isNeedTypeVideo: Bool {
                switch self {
                case .relatedToVideoId, .forMine: return true
                case .forContentOwner: return false
                }
            }
        }
        
        
        struct SubscriptionsList {
            let property:String
            let parameter:String = Const.channelId
        }
        
        struct SubscriptionsInsert {
            let property:String
            //TODO:parameterではなくrequest 本文　body?
            let parameter:String = Const.channelId
        }
        
        struct SubscriptionsDelete {
            let property:String
            let parameter:String = Const.id
        }
        
        enum Channels:ParameterType {
            case categoryId(id:String)
            case forUsername(name:String)
            case id(ids:[String])
            case mine
            
            var property:Any {
                switch self {
                case .categoryId(let id): return id
                case .forUsername(let name): return name
                case .id(let ids): return ids.joined(separator: ",")
                case .mine: return true
                }
            }
        }
        
        enum Videos: ParameterType {
            case chart
            case id(ids: [String])
            case myRating(rating: Rating)
            
            var property:Any {
                switch self {
                case .chart: return Const.mostPopular
                case .id(let ids): return ids.joined(separator: ",")
                case .myRating(let rating): return rating.rawValue
                }
            }
            
            enum Rating: String {
                case dislike
                case like
            }
        }
        
        enum Playlists: ParameterType {
            case channelId(id: String)
            case id(ids: [String])
            case mine
            
            var property:Any {
                switch self {
                case .channelId(let id): return id
                case .id(let ids): return ids.joined(separator: ",")
                case .mine: return true
                }
            }
        }
    }
    
    // MARK: Option Parameter
    
    struct OptionParameter {
        private struct Const {
            static let regionCode = "regionCode"
        }
        
        enum RegionCode: String {
            case JP
            case US
            case CN
            case FR
            case GB
            case IN
            case KR
            case TW
            case CA
            case HK
            case RU
            
            var parameter: String {
                return Const.regionCode
            }
        }
        
        enum Search:ParameterType, Hashable {
            case channelId(id:String)
            case eventType(event:Event)
            case maxResults(max:Int)
            case order(order:Order)
            case publishedAfter(time:Date)
            case publishedBefore(time:Date)
            case datetime(time:Date)
            case q(keyword:String)
            case regionCode(code:RegionCode)
            case type(types:Set<SearchType>)
            case videoCaption(caption:Caption)
            case videoCategoryId(id:String)
            case videoDefinition(definition:Definition)
            case videoDuration(duration:Duration)
            
            var property:Any {
                switch self {
                case .channelId(let id): return id
                case .eventType(let event): return event.rawValue
                case .maxResults(let max): return max
                case .order(let order): return order.rawValue
                case .publishedAfter(let time): return time
                case .publishedBefore(let time): return time
                case .datetime(let time): return time
                case .q(let keyword): return keyword
                case .regionCode(let code): return code.rawValue
                case .type(let types): return types.map { $0.rawValue }.joined(separator: ",")
                case .videoCaption(let caption): return caption.rawValue
                case .videoCategoryId(let id): return id
                case .videoDefinition(let definition): return definition.rawValue
                case .videoDuration(let duration): return duration.rawValue
                }
            }
            
            var isNeedTypeVideo: Bool {
                switch self {
                case .eventType, .videoCaption, .videoCategoryId, .videoDefinition, .videoDuration:
                    return true
                default:
                    return false
                }
            }
            
            enum Event: String {
                case completed
                case live
                case upcoming
            }
            
            enum Order: String {
                case date
                case rating
                case relevance
                case title
                case videoCount
                case viewCount
            }
            
            enum SearchType: String {
                case channel
                case playlist
                case video
            }
            
            enum Caption: String {
                case any
                case closedCaption
                case none
            }
            
            enum Definition: String {
                case any
                case high
                case standard
            }
            
            enum Duration: String {
                case any
                case long
                case medium
                case short
            }
            
            static func ==(lhs: Search, rhs: Search) -> Bool {
                switch (lhs, rhs) {
                case (.channelId, .channelId): return true
                case (.eventType, .eventType): return true
                case (.maxResults, .maxResults): return true
                case (.order, .order): return true
                case (.publishedAfter, .publishedAfter): return true
                case (.publishedBefore, .publishedBefore): return true
                case (.datetime, .datetime): return true
                case (.q, .q): return true
                case (.regionCode, .regionCode): return true
                case (.type, .type): return true
                case (.videoCaption, .videoCaption): return true
                case (.videoCategoryId, .videoCategoryId): return true
                case (.videoDefinition, .videoDefinition): return true
                case (.videoDuration, .videoDuration): return true
                default: return false
                }
            }
            
            var hashValue: Int {
                switch self {
                case .channelId: return 0
                case .eventType: return 1
                case .maxResults: return 2
                case .order: return 3
                case .publishedAfter: return 4
                case .publishedBefore: return 5
                case .datetime: return 6
                case .q: return 7
                case .regionCode: return 0
                case .type: return 9
                case .videoCaption: return 10
                case .videoCategoryId: return 11
                case .videoDefinition: return 12
                case .videoDuration: return 13
                }
            }
        }
    }
}

extension YoutubeAPI:TargetType {
    
    var baseURL: URL { return URL(string: "https://www.googleapis.com")! }
    
    var path: String {
        switch self {
        case .search:
            return "/youtube/v3/search"
        case .subscriptionsList, .subscriptionsInsert, .subscriptionsDelete:
            return "/youtube/v3/subscriptions"
        case .channels:
            return "/youtube/v3/channels"
        case .videos:
            return "/youtube/v3/videos"
        case .videoCategories:
            return "/youtube/v3/videoCategories"
        case .playlists:
            return "/youtube/v3/playlists"
        }
    }
    
    var task: Task {
        switch self {
        case .search(let require, let filter, let options):
            var params = options.reduce(into: [String:Any]()) { $0[$1.parameter] = $1.property }
            params[require.parameter] = require.properties.map { $0.rawValue }.joined(separator: ",")
            if let f = filter {
                params[f.parameter] = f.property
            }
            params[YoutubeAPI.keyParameter] = YoutubeAPI.keyProperty
            if let f = filter, f.isNeedTypeVideo || options.contains(where: { $0.isNeedTypeVideo }) {
                let type = OptionParameter.Search.type(types: [.video])
                params[type.parameter] = type.property
            }
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .subscriptionsList(let require, let filter):
            return .requestParameters(
                parameters: [require.parameter: require.properties.map { $0.rawValue }.joined(separator: ","),
                             filter.parameter: filter.property,
                             YoutubeAPI.keyParameter: YoutubeAPI.keyProperty],
                encoding: URLEncoding.default)
        case .subscriptionsInsert(let require, let filter):
            return .requestParameters(
                parameters: [require.parameter: require.properties.map { $0.rawValue }.joined(separator: ","),
                             filter.parameter: filter.property,
                             YoutubeAPI.keyParameter: YoutubeAPI.keyProperty],
                encoding: URLEncoding.default)
        case .subscriptionsDelete(let require, let filter):
            return .requestParameters(
                parameters: [require.parameter: require.property,
                             filter.parameter: filter.property,
                             YoutubeAPI.keyParameter: YoutubeAPI.keyProperty],
                encoding: URLEncoding.default)
        case .channels(let require, let filter):
            return .requestParameters(
                parameters: [require.parameter: require.properties.map { $0.rawValue }.joined(separator: ","),
                             filter.parameter: filter.property,
                             YoutubeAPI.keyParameter: YoutubeAPI.keyProperty],
                encoding: URLEncoding.default)
        case .videos(let require, let filter):
            return .requestParameters(
                parameters: [require.parameter: require.properties.map { $0.rawValue }.joined(separator: ","),
                             filter.parameter: filter.property,
                             YoutubeAPI.keyParameter: YoutubeAPI.keyProperty],
                encoding: URLEncoding.default)
        case .videoCategories(let require, let filter):
            return .requestParameters(
                parameters: [require.parameter: require.properties.map { $0.rawValue }.joined(separator: ","),
                             filter.parameter: filter.rawValue,
                             YoutubeAPI.keyParameter: YoutubeAPI.keyProperty],
                encoding: URLEncoding.default)
        case .playlists(let require, let filter):
            return .requestParameters(
                parameters: [require.parameter: require.properties.map { $0.rawValue }.joined(separator: ","),
                             filter.parameter: filter.property,
                             YoutubeAPI.keyParameter: YoutubeAPI.keyProperty],
                encoding: URLEncoding.default)
        }
    }
    
    var sampleData: Data {
        switch self {
        case .search: return stubbedResponse("search")
        case .videos: return stubbedResponse("videos")
        case .channels: return stubbedResponse("channel")
        case .subscriptionsList: return stubbedResponse("subscriptionslist")
        case .subscriptionsInsert: return stubbedResponse("subscriptionsinsert")
        case .subscriptionsDelete: return stubbedResponse("subscriptionsdelete")
        case .videoCategories: return stubbedResponse("videoCategories")
        case .playlists: return stubbedResponse("playlists")
        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .subscriptionsList:
            return .post
        case .subscriptionsDelete:
            return .delete
        default:
            return .get
        }
    }
    
    var headers: [String: String]? {
        let accessToken = ""
        let authValue = String(format: "Bearer %@", accessToken)
        return ["Authorization": authValue]
    }
    
    // MARK: - Provider support
    
    func stubbedResponse(_ filename: String) -> Data! {
        @objc class TestClass: NSObject { }
        
        let bundle = Bundle(for: TestClass.self)
        let path = bundle.path(forResource: filename, ofType: "json")
        return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
    }
    
}
