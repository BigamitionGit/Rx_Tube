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
 
 protocol ItemListViewModelType: class {
    
    // Input
    var viewDidLoad: PublishRelay<Void> { get }
    var refresh: PublishRelay<Void> { get }
    var selectedIndexPath: PublishRelay<IndexPath> { get }
    
    // Output
    var showPlayer: Signal<SearchItemDetails.Video> { get }
    var showPlaylist: Signal<SearchItemDetails.Playlist> { get }
    var pushChannelDetail: Signal<SearchItemDetails.Channel> { get }
    var itemDataSource: Driver<SearchItemCellModel> { get }
 }
 
 final class ItemListViewModel: ItemListViewModelType {
    
    // MARK: Input
    let viewDidLoad = PublishRelay<Void>()
    let refresh = PublishRelay<Void>()
    let selectedIndexPath = PublishRelay<IndexPath>()
    
    // MARK: Output
    let showPlayer: Signal<SearchItemDetails.Video>
    let showPlaylist: Signal<SearchItemDetails.Playlist>
    let pushChannelDetail: Signal<SearchItemDetails.Channel>
    let itemDataSource: Driver<SearchItemCellModel>
    
    private let disposeBag = DisposeBag()
    
    // MARK: Initializing
    
    init(searchRepository: YoutubeSearchRepositoryType,
         searchDetailRepository: YoutubeSearchDetailsRepositoryType) {
        
        let searchItemDetails: Observable<SearchItemDetails> = Observable
            .of(viewDidLoad, refresh)
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
            .share()
        
        selectedItem
            .flatMap { item in item.video.map { Observable.just($0) } ?? Observable.empty() }
            .observeOn(MainScheduler.instance)
            .bind(to: showPlayer)
            .disposed(by: disposeBag)
        
        showPlaylist = selectedItem
            .flatMap { item in item.playlist.map { Observable.just($0) } ?? Observable.empty() }
            .asSignal(onErrorSignalWith: Signal.empty())
        
        selectedItem
            .flatMap { item in item.channel.map { Observable.just($0) } ?? Observable.empty() }
            .observeOn(MainScheduler.instance)
            .bind(to: pushChannelDetail)
            .disposed(by: disposeBag)
        
    }
 }
 
 
 
 
 
 
 
 
 
 
 
