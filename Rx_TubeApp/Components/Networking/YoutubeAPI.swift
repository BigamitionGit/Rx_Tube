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

let YoutubeProvider = RxMoyaProvider<YoutubeAPI>()

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
    case search(require: RequireParameter.Search, filter:[FilterParameter.Search])
    case subscriptionsList(require: RequireParameter.Subscriptions, filter:FilterParameter.SubscriptionsList)
    case subscriptionsInsert(require: RequireParameter.Subscriptions, filter:FilterParameter.SubscriptionsInsert)
    case subscriptionsDelete(require: RequireParameter.Delete, filter:FilterParameter.SubscriptionsDelete)
    case channels(require: RequireParameter.Channels, filter:FilterParameter.Channels)
    case videos(require: RequireParameter.Videos, filter:FilterParameter.Videos)
    case playlists(require: RequireParameter.Playlists, filter:FilterParameter.Playlists)
    case videoCategories(require: RequireParameter.VideoCategory, filter:FilterParameter.RegionCode)
    
    static let keyParameter = "key"
    static let keyProperty = "AIzaSyCFCOuvjqfco2AqdsD5WrG21ZcYAoyWyBw"
    
    // MARK: RequireParameter
    
    struct RequireParameter {
        private struct Const {
            static let part = "part"
            static let id = "id"
        }
        
        struct Search {
            let parameter: String = Const.part
            let properties: [Property]
            
            enum Property: String {
                case snippet
                case id
            }
        }
        
        struct Subscriptions {
            let parameter: String = Const.part
            let properties: [Property]
            
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
            let properties: [Property]
            
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
            let properties: [Property]
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
            let properties: [Property]
            enum Property: String {
                case snippet
                case id
            }
        }
        struct Playlists {
            let parameter: String = Const.part
            let properties: [Property]
            
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
        
        enum Search:ParameterType {
            case channelId(id:String)
            case eventType(event:Event)
            case maxResults(max:Int)
            case order(order:Order)
            case publishedAfter(time:Date)
            case publishedBefore(time:Date)
            case datetime(time:Date)
            case q(keyword:String)
            case regionCode(code:RegionCode)
            case type(type:SearchType)
            case videoCaption(caption:Caption)
            case videoCategoryId(id:String)
            case videoDefinition(definition:Definition)
            case videoDuration(duration:Duration)
            
            var property:Any {
                switch self {
                case .channelId(let id):
                    return id
                case .eventType(let event):
                    return event.rawValue
                case .maxResults(let max):
                    return max
                case .order(let order):
                    return order.rawValue
                case .publishedAfter(let time):
                    return time
                case .publishedBefore(let time):
                    return time
                case .datetime(let time):
                    return time
                case .q(let keyword):
                    return keyword
                case .regionCode(let code):
                    return code.rawValue
                case .type(let type):
                    return type.rawValue
                case .videoCaption(let caption):
                    return caption.rawValue
                case .videoCategoryId(let id):
                    return id
                case .videoDefinition(let definition):
                    return definition.rawValue
                case .videoDuration(let duration):
                    return duration.rawValue
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
                case .categoryId(let id):
                    return id
                case .forUsername(let name):
                    return name
                case .id(let ids):
                    return ids.joined(separator: ",")
                case .mine:
                    return true
                }
            }
        }
        
        enum Videos: ParameterType {
            case chart
            case id(ids: [String])
            case myRating(rating: Rating)
            
            var property:Any {
                switch self {
                case .chart:
                    return Const.mostPopular
                case .id(let ids):
                    return ids.joined(separator: ",")
                case .myRating(let rating):
                    return rating.rawValue
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
                case .channelId(let id):
                    return id
                case .id(let ids):
                    return ids.joined(separator: ",")
                case .mine:
                    return true
                }
            }
        }
    }
}

extension YoutubeAPI:TargetType {
    
    var parameterEncoding: ParameterEncoding { return URLEncoding.default }
    
    var task: Task { return .request }
    
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
    
    var parameters: [String: Any]? {
        switch self {
        case .search(let requires, let filters):
            var params = filters.reduce([String:Any]()) { (result, search) -> [String:Any] in
                var result = result
                result[search.parameter] = search.property
                return result
            }
            params[requires.parameter] = requires.properties.map { $0.rawValue }.joined(separator: ",")
            params[YoutubeAPI.keyParameter] = YoutubeAPI.keyProperty
            if filters.contains(where: { $0.isNeedTypeVideo }) {
                let type = YoutubeAPI.FilterParameter.Search.type(type: YoutubeAPI.FilterParameter.Search.SearchType.video)
                params[type.parameter] = type.property
            }
            return params
        case .subscriptionsList(let require, let filter):
            return [require.parameter: require.properties.map { $0.rawValue }.joined(separator: ","), filter.parameter: filter.property]
        case .subscriptionsInsert(let require, let filter):
            return [require.parameter: require.properties.map { $0.rawValue }.joined(separator: ","), filter.parameter: filter.property]
        case .subscriptionsDelete(let require, let filter):
            return [require.parameter: require.property, filter.parameter: filter.property]
        case .channels(let require, let filter):
            return [require.parameter: require.properties.map { $0.rawValue }.joined(separator: ","), filter.parameter: filter.property]
        case .videos(let require, let filter):
            return [require.parameter: require.properties.map { $0.rawValue }.joined(separator: ","), filter.parameter: filter.property]
        case .videoCategories(let require, let filter):
            return [require.parameter: require.properties.map { $0.rawValue }.joined(separator: ","), filter.parameter: filter.rawValue]
        case .playlists(let require, let filter):
            return [require.parameter: require.properties.map { $0.rawValue }.joined(separator: ","), filter.parameter: filter.property]
        }
    }
    
    var sampleData: Data {
        switch self {
        case .search:
            return stubbedResponse("search")
        case .videos:
            return stubbedResponse("videos")
        case .channels:
            return stubbedResponse("channel")
        case .subscriptionsList:
            return stubbedResponse("subscriptionslist")
        case .subscriptionsInsert:
            return stubbedResponse("subscriptionsinsert")
        case .subscriptionsDelete:
            return stubbedResponse("subscriptionsdelete")
        case .videoCategories:
            return stubbedResponse("videoCategories")
        case .playlists:
            return stubbedResponse("playlists")
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
    
    // MARK: - Provider support
    
    func stubbedResponse(_ filename: String) -> Data! {
        @objc class TestClass: NSObject { }
        
        let bundle = Bundle(for: TestClass.self)
        let path = bundle.path(forResource: filename, ofType: "json")
        return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
    }
    
}
