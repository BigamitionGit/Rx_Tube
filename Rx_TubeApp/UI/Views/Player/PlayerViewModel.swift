//
//  PlayerViewModel.swift
//  Rx_TubeApp
//
//  Created by 細田　大志 on 2017/07/14.
//  Copyright © 2017 HIroshi Hosoda. All rights reserved.
//

import RxSwift
import RxCocoa

protocol PlayerViewModelType {
    
    /// Input
    
    /// video in Other than Player
    var videoDidTap: PublishSubject<(Videos.Item, Channels.Item)> { get }
    /// related video in player
    var relatedVideoDidTap: PublishSubject<IndexPath> { get }
    var channelDidTap: PublishSubject<Void> { get }
    var likeDidTap: PublishSubject<Void> { get } 
    var dislikeDidTap: PublishSubject<Void> { get }
    var nextDidTap: PublishSubject<Void> { get }
    var previousDidTap: PublishSubject<Void> { get }
    
    /// Output
    
    var play: Driver<String> { get }
    var showChannelDetail: Driver<String> { get }
    var overview: Driver<VideoOverviewViewModelType> { get }
    var relatedVideoCellModels: Driver<[RelatedVideoCellModel]> { get }
}

final class PlayerViewModel: PlayerViewModelType {
    
    let videoDidTap = PublishSubject<(Videos.Item, Channels.Item)>()
    let relatedVideoDidTap = PublishSubject<IndexPath>()
    let channelDidTap = PublishSubject<Void>()
    let likeDidTap = PublishSubject<Void>()
    let dislikeDidTap = PublishSubject<Void>()
    let nextDidTap = PublishSubject<Void>()
    let previousDidTap = PublishSubject<Void>()
    
    let play: Driver<String>
    let showChannelDetail: Driver<String>
    var overview: Driver<VideoOverviewViewModelType>
    var relatedVideoCellModels: Driver<[RelatedVideoCellModel]>
    
    init(service: YoutubeServiceType) {
        
        let relatedItems: Observable<SearchItems> = videoDidTap
            .flatMap { (video, _) in service.fetchSearchItems(
                YoutubeAPI.RequireParameter.Search(properties: [.snippet, .id]),
                YoutubeAPI.FilterParameter.Search.relatedToVideoId(id: video.id),
                Set<YoutubeAPI.OptionParameter.Search>()) }
            .share(replay: 1)
        
        relatedVideoCellModels = relatedItems
            .map { searchItems in searchItems.items
                .map { RelatedVideoCellModel(item: $0.snippet) }}
            .asDriver(onErrorJustReturn: [])
        
        let relatedVideosChannels = relatedItems
            .flatMap { items in
                let videos = service.fetchVideos
            return Observable.combineLatest()
        }
        
        let item: Observable<(Videos.Item, Channels.Item)> = relatedVideoDidTap
            .withLatestFrom(relatedVideos) {(indexPath, videos)->RelatedVideoCellModel in videos[indexPath.row] }
            .flatMap { relatedVideo -> Observable<(Videos.Item, Channels.Item)> in
                let video = service.fetchVideo(
                    YoutubeAPI.RequireParameter.Videos(properties: [.snippet, .statistics, .player, .contentDetails]),
                    relatedVideo.id)
                
                let channel = service.fetchChannel(
                    YoutubeAPI.RequireParameter.Channels(properties: [.snippet, .id, .statistics, .contentDetails]),
                    relatedVideo.channelId)
                
                return Observable
                    .combineLatest(video, channel)
        }.shareReplay(1)
        
        let a = Observable.of(videoDidTap, item).merge()
        
        
        relatedVideos = videoDidTap
            .flatMap { video in service.fetchChannels(
                YoutubeAPI.RequireParameter.Channels(properties: [.snippet, .id, .statistics, .contentDetails]),
                YoutubeAPI.FilterParameter.Channels.id(ids: [video.snippet?.channelId])) }
        
        showChannelDetail = channelDidTap
            .asDriver(onErrorDriveWith: Driver.empty())
    }
}
