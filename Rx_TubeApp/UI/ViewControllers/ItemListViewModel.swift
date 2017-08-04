//
//  ItemListViewModel.swift
//  Rx_TubeApp
//
//  Created by 細田　大志 on 2017/07/11.
//  Copyright © 2017 HIroshi Hosoda. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxMoya
import Moya

typealias Search = YoutubeAPI.SearchParameter

// MARK: Types

enum ItemListViewType {
    case short
    case long
    case event
    case latest
    case viewCount
    case rating
    case period
    case region
    case caption
    case HD
    
    var parameters:[Search] {
        switch self {
        case .short:
            return [Search.videoDuration(duration: Search.Duration.short)]
        case .long:
            return [Search.videoDuration(duration: Search.Duration.long)]
        case .event:
            return [Search.eventType(event: Search.Event.live)]
        case .latest:
            return [Search.order(order: Search.Order.date)]
        case .viewCount:
            return [Search.order(order: Search.Order.viewCount)]
        case .rating:
            return [Search.order(order: Search.Order.rating)]
        case .period:
            //TODO change date
            return [Search.publishedBefore(time: Date()), Search.publishedAfter(time: Date())]
        case .region:
            // Default US
            return [Search.regionCode(code: YoutubeAPI.RegionCode.US)]
        case .caption:
            return [Search.videoCaption(caption: Search.Caption.closedCaption)]
        case .HD:
            return [Search.videoDefinition(definition: Search.Definition.high)]
        }
    }
}

final class ItemListViewModel {
    
    // Input
    var searchText = Variable("")
    var searchKeyDidTap = PublishSubject<Void>()
    var videoCategory = Variable("")
    var selectedTab = PublishSubject<Void> ()
    var refresh = PublishSubject<Void>()
    var horizontalSwipe = PublishSubject<Void>()
    var selectedItem = PublishSubject<IndexPath>()
    
    // Output
    let presentPlayerViewModel: Observable<PlayerViewModel>
    let itemDataSource: Driver<[SearchItemCellModel]>
    
    // MARK: Initializing
    
    init(provider: RxMoyaProvider<YoutubeAPI>, type: ItemListViewType) {
        
        let cellModels: Observable<[SearchItemCellModel]> = Observable
            .of(searchKeyDidTap, selectedTab, refresh, horizontalSwipe)
            .merge()
            .withLatestFrom(searchText.asObservable())
            .withLatestFrom(videoCategory.asObservable()) { ($0, $1) }
            .flatMapLatest { text, category -> Observable<Response> in
                var parameters = type.parameters
                if !text.isEmpty { parameters.append(Search.q(keyword: text)) }
                if !category.isEmpty { parameters.append(Search.videoCategoryId(id: category)) }
                return provider.request(YoutubeAPI.search(parameters:parameters))
                    .retry(3)
                    .observeOn(MainScheduler.instance) }
            .map { (response:Moya.Response) -> SearchItems in
                let decoder: JSONDecoder = JSONDecoder()
                return try decoder.decode(SearchItems.self, from: response.data)
            }.map { items in
                return items.items
                    .map { SearchItemCellModel(item: $0) }
                    .flatMap { $0 }
            }.shareReplay(1)
        
        itemDataSource = cellModels.asDriver(onErrorJustReturn: [])
        
        presentPlayerViewModel = selectedItem
            .withLatestFrom(cellModels) { ($0, $1) }
            .map { index, models in
                let model = models[index.row]
                return PlayerViewModel(provider: provider,
                                       parameter: YoutubeAPI.VideosParameter.id(id: model.type.id))
        }
    }
}











