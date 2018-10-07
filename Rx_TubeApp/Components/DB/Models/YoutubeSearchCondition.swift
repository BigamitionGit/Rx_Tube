//
//  YoutubeSearchCondition.swift
//  Rx_TubeApp
//
//  Created by 細田大志 on 2018/10/07.
//  Copyright © 2018 HIroshi Hosoda. All rights reserved.
//

import Foundation
import RealmSwift

class YoutubeSearchConditionRealmObject: Object, ConvertibleToModel {
    
    @objc dynamic var searchQuery: String? = nil
    @objc dynamic var channelId: String? = nil
    @objc dynamic var event: String? = nil
    @objc dynamic var orderType: String? = nil
    @objc dynamic var publishedAfter: Date? = nil
    @objc dynamic var publishedBefore: Date? = nil
    @objc dynamic var regionCode: String? = nil
    var searchTypes: List<String> = List<String>()
    @objc dynamic var caption: String? = nil
    @objc dynamic var videoCategoryid: String? = nil
    @objc dynamic var definition: String? = nil
    @objc dynamic var duration: String? = nil
    
    func toModel() -> YoutubeSearchCondition {
        return YoutubeSearchCondition(
            searchQuery: searchQuery,
            channelId: channelId,
            event: event.flatMap { YoutubeAPI.OptionParameter.Search.Event(rawValue: $0) },
            orderType: orderType.flatMap { YoutubeAPI.OptionParameter.Search.Order(rawValue: $0) },
            publishedAfter: publishedAfter,
            publishedBefore: publishedBefore,
            regionCode: regionCode.flatMap { YoutubeAPI.OptionParameter.RegionCode(rawValue: $0) },
            searchTypes: Set(searchTypes.compactMap { YoutubeAPI.OptionParameter.Search.SearchType(rawValue: $0) }),
            caption: caption.flatMap { YoutubeAPI.OptionParameter.Search.Caption(rawValue: $0) },
            videoCategoryid: videoCategoryid,
            definition: definition.flatMap { YoutubeAPI.OptionParameter.Search.Definition(rawValue:  $0) },
            duration: duration.flatMap { YoutubeAPI.OptionParameter.Search.Duration(rawValue: $0) })
    }
}

struct YoutubeSearchCondition: ConvertibleToRealmObject {
    
    let searchQuery: String?
    let channelId: String?
    let event: YoutubeAPI.OptionParameter.Search.Event?
    let orderType: YoutubeAPI.OptionParameter.Search.Order?
    let publishedAfter: Date?
    let publishedBefore: Date?
    let regionCode: YoutubeAPI.OptionParameter.RegionCode?
    let searchTypes: Set<YoutubeAPI.OptionParameter.Search.SearchType>
    let caption: YoutubeAPI.OptionParameter.Search.Caption?
    let videoCategoryid: String?
    let definition: YoutubeAPI.OptionParameter.Search.Definition?
    let duration: YoutubeAPI.OptionParameter.Search.Duration?
    
    init(searchQuery: String? = nil,
         channelId: String? = nil,
         event: YoutubeAPI.OptionParameter.Search.Event? = nil,
         orderType: YoutubeAPI.OptionParameter.Search.Order? = nil,
         publishedAfter: Date? = nil,
         publishedBefore: Date? = nil,
         regionCode: YoutubeAPI.OptionParameter.RegionCode? = nil,
         searchTypes: Set<YoutubeAPI.OptionParameter.Search.SearchType> = Set(),
         caption: YoutubeAPI.OptionParameter.Search.Caption? = nil,
         videoCategoryid: String? = nil,
         definition: YoutubeAPI.OptionParameter.Search.Definition? = nil,
         duration: YoutubeAPI.OptionParameter.Search.Duration? = nil) {
        
        self.searchQuery = searchQuery
        self.channelId = channelId
        self.event = event
        self.orderType = orderType
        self.publishedAfter = publishedAfter
        self.publishedBefore = publishedBefore
        self.regionCode = regionCode
        self.searchTypes = searchTypes
        self.caption = caption
        self.videoCategoryid = videoCategoryid
        self.definition = definition
        self.duration = duration
    }
    
    func toRealmObject() -> YoutubeSearchConditionRealmObject {
        let realmObject = YoutubeSearchConditionRealmObject()
        realmObject.searchQuery = searchQuery
        realmObject.channelId = channelId
        realmObject.event = event?.rawValue
        realmObject.orderType = orderType?.rawValue
        realmObject.publishedAfter = publishedAfter
        realmObject.publishedAfter = publishedAfter
        realmObject.regionCode = regionCode?.rawValue
        realmObject.searchTypes = List(searchTypes.map { $0.rawValue })
        realmObject.caption = caption?.rawValue
        realmObject.videoCategoryid = videoCategoryid
        realmObject.definition = definition?.rawValue
        realmObject.duration = duration?.rawValue
        return realmObject
    }
    
    func toYoutubeSearchOptionParameter() -> Set<YoutubeAPI.OptionParameter.Search> {
        let searchQParam = searchQuery.map { YoutubeAPI.OptionParameter.Search.q(keyword: $0) }
        let channelIdParam = channelId.map { YoutubeAPI.OptionParameter.Search.channelId(id: $0) }
        let eventParam = event.map { YoutubeAPI.OptionParameter.Search.eventType(event: $0) }
        let orderParam = orderType.map { YoutubeAPI.OptionParameter.Search.order(order: $0) }
        let publishedAfterParam = publishedAfter.map { YoutubeAPI.OptionParameter.Search.publishedAfter(time: $0) }
        let publishedBeforeParam = publishedBefore.map { YoutubeAPI.OptionParameter.Search.publishedBefore(time: $0) }
        let regionCodeParam = regionCode.map { YoutubeAPI.OptionParameter.Search.regionCode(code: $0) }
        let typeParam = YoutubeAPI.OptionParameter.Search.type(types: searchTypes)
        let videoCaptionParam = caption.map { YoutubeAPI.OptionParameter.Search.videoCaption(caption: $0) }
        let videoDefinitionParam = definition.map { YoutubeAPI.OptionParameter.Search.videoDefinition(definition: $0) }
        let videoDurationParam = duration.map { YoutubeAPI.OptionParameter.Search.videoDuration(duration: $0) }
        
        let params = [searchQParam,
                      channelIdParam,
                      eventParam,
                      orderParam,
                      publishedAfterParam,
                      publishedBeforeParam,
                      regionCodeParam,
                      typeParam,
                      videoCaptionParam,
                      videoDefinitionParam,
                      videoDurationParam]
            .compactMap { $0 }
        
        return Set(params)
    }
}
