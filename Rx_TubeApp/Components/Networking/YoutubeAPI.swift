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
    var key: String { get }
}

extension ParameterType {
    var key: String {
        let keyString = String(describing: self)
        guard let index = keyString.index(of: "(") else { return keyString }
        return String(keyString[..<index])
    }
}

enum YoutubeAPI {
    case search(require: SearchRequireParameter, filter:[SearchParameter])
    case subscriptionsList(require: SubscriptionsRequireParameter, filter:SubscriptionsListParameter)
    case subscriptionsInsert(require: SubscriptionsRequireParameter, filter:SubscriptionsInsertParameter)
    case subscriptionsDelete(require: DeleteRequireParameter, filter:SubscriptionsDeleteParameter)
    case channels(require: ChannelsRequireParameter, filter:ChannelsParameter)
    case videos(require: VideosRequireParameter, filter:VideosParameter)
    case videoCategories(require: VideoCategoryRequireParameter, filter:RegionCode)
    
    static let keyParameter = "key"
    static let keyProperty = "AIzaSyCFCOuvjqfco2AqdsD5WrG21ZcYAoyWyBw"
    
    // MARK: RequireParameter
    
    struct SearchRequireParameter {
        let parameter: String = "part"
        let properties: [Property]
        
        enum Property: String {
            case snippet
            case id
        }
    }
    
    struct SubscriptionsRequireParameter {
        let parameter: String = "part"
        let properties: [Property]
        
        enum Property: String {
            case snippet
            case id
            case contentDetails
        }
    }
    
    struct DeleteRequireParameter {
        let parameter: String = "id"
        var property: String // Specify the YouTube subscription channel ID.
    }
    
    struct ChannelsRequireParameter {
        let parameter: String = "part"
        let properties: [Property]
        
        enum Property: String {
            case snippet
            case id
            case brandingSettings
            case contentDetails
            case invideoPromotion
            case statistics
            case topicDetails
        }
    }
    
    struct VideosRequireParameter {
        let parameter: String = "part"
        let properties: [Property]
        enum Property: String {
            case snippet
            case id
            case contentDetails
            case fileDetails
            case liveStreamingDetails
            case player
            case processingDetails
            case recordingDetails
            case statistics
            case status
            case suggestions
            case topicDetails
        }
    }
    
    struct VideoCategoryRequireParameter {
        let parameter: String = "part"
        let properties: [Property]
        enum Property: String {
            case snippet
            case id
        }
    }
    
    // MARK: Filter Parameter
    
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
        
        var key: String {
            return "regionCode"
        }
    }
    
    struct SubscriptionsListParameter {
        let value:String
        let key:String = "channelId"
    }
    
    struct SubscriptionsInsertParameter {
        let value:String
        //TODO:parameterではなくrequest 本文　body?
        let key:String = "channelId"
    }
    
    struct SubscriptionsDeleteParameter {
        let value:String
        let key:String = "id"
    }
    
    enum ChannelsParameter:ParameterType {
        case categoryId(id:String)
        case forUsername(name:String)
        case id(id:String)
        
        var value:Any {
            switch self {
            case .categoryId(let id):
                return id
            case .forUsername(let name):
                return name
            case .id(let id):
                return id
            }
        }
    }
    
    enum VideosParameter:ParameterType {
        case chart
        case id(id:String)
        case myRating(rating:Rating)
        
        var value:Any {
            switch self {
            case .chart:
                return "mostPopular"
            case .id(let id):
                return id
            case .myRating(let rating):
                return rating.rawValue
            }
        }
        
        enum Rating: String {
            case dislike
            case like
        }
    }
    
    enum SearchParameter:ParameterType {
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
        
        var value:Any {
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
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .search(let rParams, let fParams):
            var params = fParams.reduce([String:Any]()) { (result, parameter) -> [String:Any] in
                var result = result
                result[parameter.key] = parameter.value
                return result
            }
            params[rParams.parameter] = rParams.properties.map { $0.rawValue }.joined(separator: ",")
            params[YoutubeAPI.keyParameter] = YoutubeAPI.keyProperty
            if fParams.contains(where: { $0.isNeedTypeVideo }) {
                let type = YoutubeAPI.SearchParameter.type(type: YoutubeAPI.SearchParameter.SearchType.video)
                params[type.key] = type.value
            }
            return params
        case .subscriptionsList(let rParam, let fParam):
            return [rParam.parameter: rParam.properties.map { $0.rawValue }.joined(separator: ","), fParam.key: fParam.value]
        case .subscriptionsInsert(let rParam, let fParam):
            return [rParam.parameter: rParam.properties.map { $0.rawValue }.joined(separator: ","), fParam.key: fParam.value]
        case .subscriptionsDelete(let rParam, let fParam):
            return [rParam.parameter: rParam.property, fParam.key: fParam.value]
        case .channels(let rParam, let fParam):
            return [rParam.parameter: rParam.properties.map { $0.rawValue }.joined(separator: ","), fParam.key: fParam.value]
        case .videos(let rParam, let fParam):
            return [rParam.parameter: rParam.properties.map { $0.rawValue }.joined(separator: ","), fParam.key: fParam.value]
        case .videoCategories(let rParam, let fParam):
            return [rParam.parameter: rParam.properties.map { $0.rawValue }.joined(separator: ","), fParam.key: fParam.rawValue]
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
