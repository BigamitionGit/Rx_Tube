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
 
 fileprivate typealias SearchFilter = YoutubeAPI.FilterParameter.Search
 fileprivate typealias SearchOption = YoutubeAPI.OptionParameter.Search
 fileprivate typealias SearchRequire = YoutubeAPI.RequireParameter.Search
 fileprivate typealias ChannelsFilter = YoutubeAPI.FilterParameter.Channels
 fileprivate typealias ChannelsRequire = YoutubeAPI.RequireParameter.Channels
 fileprivate typealias VideosFilter = YoutubeAPI.FilterParameter.Videos
 fileprivate typealias VideosRequire = YoutubeAPI.RequireParameter.Videos
 fileprivate typealias PlaylistsFilter = YoutubeAPI.FilterParameter.Playlists
 fileprivate typealias PlaylistsRequire = YoutubeAPI.RequireParameter.Playlists
 
 
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
    
    fileprivate var requireParameters: SearchRequire {
        return SearchRequire(properties: [SearchRequire.Property.id, SearchRequire.Property.snippet])
    }
    
    fileprivate var filterParameters:Set<SearchOption> {
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
    var searchText: Variable<String> { get }
    var searchKeyDidTap: PublishSubject<Void> { get }
    var videoCategory: Variable<String> { get }
    var selectedTab: PublishSubject<Void> { get }
    var refresh: PublishSubject<Void> { get }
    var horizontalSwipe: PublishSubject<Void> { get }
    var selectedItem: PublishSubject<Int> { get }
    
    // Output
    var showPlayer: Driver<Videos.Item> { get }
    var showPlaylist: Driver<Playlists.Item> { get }
    var pushChannelDetail: Driver<Channels.Item> { get }
    var itemDataSource: Driver<[SearchItemCellModel]> { get }
 }
 
 final class ItemListViewModel: ItemListViewModelType {
    
    // MARK: Input
    var viewDidLoad = PublishSubject<Void>()
    var searchText = Variable("")
    var searchKeyDidTap = PublishSubject<Void>()
    var videoCategory = Variable("")
    var selectedTab = PublishSubject<Void> ()
    var refresh = PublishSubject<Void>()
    var horizontalSwipe = PublishSubject<Void>()
    var selectedItem = PublishSubject<Int>()
    
    // MARK: Output
    let showPlayer: Driver<Videos.Item>
    let showPlaylist: Driver<Playlists.Item>
    let pushChannelDetail: Driver<Channels.Item>
    let itemDataSource: Driver<[SearchItemCellModel]>
    
    private let disposeBag = DisposeBag()
    
    // MARK: Initializing
    
    init(service: YoutubeServiceType, type: ItemListViewType) {
        
        let searchItems: Observable<SearchItems> = Observable
            .of(viewDidLoad, searchKeyDidTap, selectedTab, refresh, horizontalSwipe)
            .merge()
            .withLatestFrom(searchText.asObservable())
            .withLatestFrom(videoCategory.asObservable()) { ($0, $1) }
            .flatMapLatest { text, category -> Observable<SearchItems> in
                var parameters = type.filterParameters
                if !text.isEmpty { parameters.insert(SearchOption.q(keyword: text)) }
                if !category.isEmpty { parameters.insert(SearchOption.videoCategoryId(id: category)) }
                return service.fetchSearchItems(type.requireParameters, nil, parameters)}
        
        
        
        let models: Observable<(videos: Videos, channels: Channels, playlists: Playlists)> = searchItems
            .flatMapLatest { (searchItems)->Observable<(videos: Videos, channels: Channels, playlists: Playlists)> in
                let videoIds = searchItems.items.filter { .video == $0.id }.flatMap { $0.id.videoId }
                let channelIds = searchItems.items.map { $0.snippet.channelId }
                let playlistIds = searchItems.items.flatMap { $0.id.playlistId }
                
                let videos = service.fetchVideos(
                    VideosRequire(properties: [ .snippet, .statistics, .player]),
                    VideosFilter.id(ids: videoIds))
                
                let channels = service.fetchChannels(
                    ChannelsRequire(properties: [.snippet, .contentDetails, .statistics]),
                    ChannelsFilter.id(ids: channelIds))
                
                let playlists = service.fetchPlaylists(
                    PlaylistsRequire(properties: [.snippet, .contentDetails, .player]), PlaylistsFilter.id(ids: playlistIds))
                
                return Observable
                    .combineLatest(videos, channels, playlists) { (videos: $0, channels: $1, playlists: $2)}
        }.shareReplay(1)
        
        let cellModels: Observable<[SearchItemCellModel]> = models
            .withLatestFrom(searchItems) { model, items in
                // video
                let vCellModels = model.videos.items
                    .flatMap { video in model.channels.items
                        .first(where: { video.snippet?.channelId == $0.id })
                        .flatMap { channel in (video, channel) }
                    }
                    .flatMap { SearchItemCellModel.Video(video: $0.0, channel: $0.1)
                        .flatMap {SearchItemCellModel.video($0)}}
                // channel
                let searchChannelIds = items.items.flatMap { $0.id.channelId }
                let cCellModel = model.channels.items
                    .filter { searchChannelIds.contains($0.id) }
                    .flatMap { SearchItemCellModel.Channel(channel: $0).flatMap { SearchItemCellModel.channel($0)}}
                // playlist
                let pCellModel = model.playlists.items
                    .flatMap { playlist in model.channels.items
                        .first(where: { playlist.snippet?.channelId == $0.id })
                        .flatMap { channel in (playlist, channel)} }
                    .flatMap { SearchItemCellModel.Playlist(playlist: $0.0, channel: $0.1)
                        .flatMap { SearchItemCellModel.playlist($0)}}
                
                return vCellModels + cCellModel + pCellModel
                
            }
            .shareReplay(1)
        
        
        itemDataSource = cellModels.asDriver(onErrorDriveWith: Driver.empty())
        
        let selectedCellModel = selectedItem
            .withLatestFrom(cellModels) { index, models in models[index] }
        
        showPlayer = selectedCellModel
            .withLatestFrom(models) { cellModel, models->Videos.Item? in
                return models.videos.items.first(where: { item in cellModel.itemId == item.id })}
            .flatMap { item in item.flatMap { Observable.just($0)} ?? Observable.empty() }
            .asDriver(onErrorDriveWith: Driver.empty())
        
        showPlaylist = selectedCellModel.withLatestFrom(models) { cellModel, models->Playlists.Item? in
            return models.playlists.items.first(where: { item in cellModel.itemId == item.id })}
            .flatMap { item in item.flatMap { Observable.just($0)} ?? Observable.empty() }
            .asDriver(onErrorDriveWith: Driver.empty())
        
        pushChannelDetail = selectedCellModel.withLatestFrom(models) { cellModel, models->Channels.Item? in
            return models.channels.items.first(where: { item in cellModel.itemId == item.id })}
            .flatMap { item in item.flatMap { Observable.just($0)} ?? Observable.empty() }
            .asDriver(onErrorDriveWith: Driver.empty())
        
    }
 }
 
 
 
 
 
 
 
 
 
 
 
