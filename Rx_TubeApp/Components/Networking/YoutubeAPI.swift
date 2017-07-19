//
//  YoutubeAPI.swift
//  Rx_TubeApp
//
//  Created by 細田　大志 on 2017/07/01.
//  Copyright © 2017 HIroshi Hosoda. All rights reserved.
//

import Foundation
import Moya

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
        guard let index = keyString.range(of: "(")?.lowerBound else { return keyString }
        return keyString.substring(to: index)
    }
}

enum YoutubeAPI {
    case search(parameters:[SearchParameter])
    case subscriptionsList(parameter:SubscriptionsListParameter)
    case subscriptionsInsert(parameter:SubscriptionsInsertParameter)
    case subscriptionsDelete(parameter:SubscriptionsDeleteParameter)
    case channels(parameter:ChannelsParameter)
    case videos(parameter:VideosParameter)
    case videoCategories(parameter:RegionCode)
    
    
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
        
        static let key = "regionCode"
        
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
    
    var parameterEncoding: ParameterEncoding { return JSONEncoding.default }
    
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
        case .search(let parameters):
            return parameters.reduce([String:Any]()) { (result, parameter) -> [String:Any] in
                var result = result
                result[parameter.key] = parameter.value
                return result
            }
        case .subscriptionsList(let parameter):
            return [parameter.key:parameter.value]
        case .subscriptionsInsert(let parameter):
            return [parameter.key:parameter.value]
        case .subscriptionsDelete(let parameter):
            return [parameter.key:parameter.value]
        case .channels(let parameter):
            return [parameter.key:parameter.value]
        case .videos(let parameter):
            return [parameter.key:parameter.value]
        case .videoCategories(let parameter):
            return [RegionCode.key:parameter.rawValue]
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
