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
 
 fileprivate typealias SearchOption = YoutubeAPI.OptionParameter.Search
 fileprivate typealias SearchRequire = YoutubeAPI.RequireParameter.Search
 
 // MARK: Types
 
 enum ItemListViewType {
    case short
    case long
    case event
    case latest
    case viewCount
    case rating
    case region
    case caption
    case HD
    
    fileprivate var requireParameters: SearchRequire {
        return SearchRequire(properties: [SearchRequire.Property.id, SearchRequire.Property.snippet])
    }
    
    fileprivate var optionParameters:Set<SearchOption> {
        switch self {
        case .short:
            return [SearchOption.videoDuration(duration: SearchOption.Duration.short)]
        case .long:
            return [SearchOption.videoDuration(duration: SearchOption.Duration.long)]
        case .event:
            return [SearchOption.eventType(event: SearchOption.Event.live)]
        case .latest:
            return [SearchOption.order(order: SearchOption.Order.date)]
        case .viewCount:
            return [SearchOption.order(order: SearchOption.Order.viewCount)]
        case .rating:
            return [SearchOption.order(order: SearchOption.Order.rating)]
        case .period:
            //TODO change date
            return [SearchOption.publishedBefore(time: Date()), SearchOption.publishedAfter(time: Date())]
        case .region:
            // Default US
            return [SearchOption.regionCode(code: YoutubeAPI.OptionParameter.RegionCode.US)]
        case .caption:
            return [SearchOption.videoCaption(caption: SearchOption.Caption.closedCaption)]
        case .HD:
            return [SearchOption.videoDefinition(definition: SearchOption.Definition.high)]
        }
    }
 }
 
 protocol ItemListViewModelType: class {
    
    // Input
    var viewDidLoad: PublishSubject<Void> { get }
    var searchText: BehaviorRelay<String> { get }
    var searchKeyDidTap: PublishSubject<Void> { get }
    var videoCategory: BehaviorRelay<String> { get }
    var selectedTab: PublishSubject<Void> { get }
    var refresh: PublishSubject<Void> { get }
    var horizontalSwipe: PublishSubject<Void> { get }
    var selectedIndexPath: PublishSubject<IndexPath> { get }
    
    // Output
    var showPlayer: PublishRelay<SearchItemDetails.Video> { get }
    var showPlaylist: Driver<SearchItemDetails.Playlist> { get }
    var pushChannelDetail: PublishRelay<SearchItemDetails.Channel> { get }
    var itemDataSource: Driver<SearchItemCellModel> { get }
 }
 
 final class ItemListViewModel: ItemListViewModelType {
    
    // MARK: Input
    var viewDidLoad = PublishSubject<Void>()
    var searchText = BehaviorRelay(value: "")
    var searchKeyDidTap = PublishSubject<Void>()
    var videoCategory = BehaviorRelay(value: "")
    var selectedTab = PublishSubject<Void> ()
    var refresh = PublishSubject<Void>()
    var horizontalSwipe = PublishSubject<Void>()
    var selectedIndexPath = PublishSubject<IndexPath>()
    
    // MARK: Output
    let showPlayer = PublishRelay<SearchItemDetails.Video>()
    let showPlaylist: Driver<SearchItemDetails.Playlist>
    let pushChannelDetail = PublishRelay<SearchItemDetails.Channel>()
    let itemDataSource: Driver<SearchItemCellModel>
    
    private let disposeBag = DisposeBag()
    
    // MARK: Initializing
    
    init(searchRepository: YoutubeSearchRepositoryType,
         searchDetailRepository: YoutubeSearchDetailsRepositoryType,
         type: ItemListViewType) {
        
        let searchItemDetails: Observable<SearchItemDetails> = Observable
            .of(viewDidLoad, searchKeyDidTap, selectedTab, refresh, horizontalSwipe)
            .merge()
            .withLatestFrom(searchText)
            .withLatestFrom(videoCategory) { ($0, $1) }
            .flatMapLatest { text, category -> Single<SearchItems> in
                var options = type.optionParameters
                if !text.isEmpty { options.insert(SearchOption.q(keyword: text)) }
                if !category.isEmpty { options.insert(SearchOption.videoCategoryId(id: category)) }
                return searchRepository.fetch(options) }
            .map { model->[(itemId: SearchItemId, channelId: String)] in ( model.items.map { ($0.id, $0.snippet.channelId) } ) }
            .flatMap(searchDetailRepository.fetch)
            .share(replay: 1)
        
        
        itemDataSource = searchItemDetails
            .map(SearchItemCellModel.init)
            .asDriver(onErrorDriveWith: Driver.empty())
        
        let selectedItem = selectedIndexPath
            .withLatestFrom(searchItemDetails) { indexPath, model in model.items[indexPath.row] }
            .share(replay: 1)
        
        selectedItem
            .flatMap { item in item.video.map { Observable.just($0) } ?? Observable.empty() }
            .observeOn(MainScheduler.instance)
            .bind(to: showPlayer)
            .disposed(by: disposeBag)
        
        
        showPlaylist = selectedItem
            .flatMap { item in item.playlist.map { Observable.just($0) } ?? Observable.empty() }
            .asDriver(onErrorDriveWith: Driver.empty())
        
        selectedItem
            .flatMap { item in item.channel.map { Observable.just($0) } ?? Observable.empty() }
            .observeOn(MainScheduler.instance)
            .bind(to: pushChannelDetail)
            .disposed(by: disposeBag)
        
    }
 }
 
 
 
 
 
 
 
 
 
 
 
