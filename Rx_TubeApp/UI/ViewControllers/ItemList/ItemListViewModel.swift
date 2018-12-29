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
 
 // MARK: Types
 
 protocol ItemListViewModelType: class {
    
    // Input
    var refresh: PublishRelay<Void> { get }
    var search: PublishRelay<YoutubeSearchCondition>  { get }
    var selectedIndexPath: PublishRelay<IndexPath> { get }
    
    // Output
    var showPlayer: Signal<Void> { get }
    var playVideo: Signal<SearchItemDetails.Video> { get }
    var showPlaylist: Signal<SearchItemDetails.Playlist> { get }
    var showChannelDetail: Signal<SearchItemDetails.Channel> { get }
    var itemDataSource: Driver<[SearchItemCellModel]> { get }
 }
 
 final class ItemListViewModel: ItemListViewModelType {
    
    // MARK: Input
    let refresh = PublishRelay<Void>()
    var search = PublishRelay<YoutubeSearchCondition>()
    let selectedIndexPath = PublishRelay<IndexPath>()
    
    // MARK: Output
    let showPlayer: Signal<Void>
    let playVideo: Signal<SearchItemDetails.Video>
    let showPlaylist: Signal<SearchItemDetails.Playlist>
    let showChannelDetail: Signal<SearchItemDetails.Channel>
    let itemDataSource: Driver<[SearchItemCellModel]>
    
    private let disposeBag = DisposeBag()
    
    // MARK: Initializing
    
    init(searchRepository: YoutubeSearchRepositoryType,
         searchDetailRepository: YoutubeSearchDetailsRepositoryType,
         itemListDataSourceTranslator: ItemListDataSourceTranslatorType) {
        
        let searchItemDetails = search.map { $0.toYoutubeSearchOptionParameter() }
            .flatMap(searchRepository.fetch)
            .map { model->[(itemId: SearchItemId, channelId: String)] in ( model.items.map { ($0.id, $0.snippet.channelId) } ) }
            .flatMap(searchDetailRepository.fetch)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .share(replay: 1)
        
        itemDataSource = searchItemDetails
            .map(itemListDataSourceTranslator.translate)
            .asDriver(onErrorDriveWith: Driver.empty())
        
        let selectedItem = selectedIndexPath
            .withLatestFrom(searchItemDetails) { indexPath, model in model.items[indexPath.row] }
            .share()
        
        let selectedVideo = selectedItem
            .flatMap { item in item.video.map { Observable.just($0) } ?? Observable.empty() }
            .share()
        
        showPlayer = selectedVideo.map { _ in () }
            .asSignal(onErrorSignalWith: Signal.empty())
        
        playVideo = selectedVideo
            .asSignal(onErrorSignalWith: Signal.empty())
        
        showPlaylist = selectedItem
            .flatMap { item in item.playlist.map { Observable.just($0) } ?? Observable.empty() }
            .asSignal(onErrorSignalWith: Signal.empty())
        
        showChannelDetail = selectedItem
            .flatMap { item in item.channel.map { Observable.just($0) } ?? Observable.empty() }
            .asSignal(onErrorSignalWith: Signal.empty())
        
    }
 }
 
 
 
 
 
 
 
 
 
 
 
