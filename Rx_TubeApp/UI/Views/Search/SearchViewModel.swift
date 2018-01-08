//
//  SearchViewModel.swift
//  Rx_TubeApp
//
//  Created by 細田　大志 on 2017/10/06.
//  Copyright © 2017 HIroshi Hosoda. All rights reserved.
//

import RxSwift
import RxCocoa

protocol SearchViewModelType {
    
    // Input
    var initialize: PublishSubject<Void> { get }
    var categoryDidTap: PublishSubject<String> { get }
    var historyDidTap: PublishSubject<[SearchViewModel.Option]> { get }
    var inputSearchKeyword: Variable<String?> { get }
    var searchDidTap: PublishSubject<Void> { get }
    
    // Output
    var dataSource: Driver<[SearchViewModel.DataSource]> { get }
    var cancel: Driver<Void> { get }
    var search: Driver<[SearchViewModel.Option]> { get }
}

final class SearchViewModel: SearchViewModelType {
    
    enum Option {
        case keyword(String)
        case category(String)
    }
    
    enum DataSource {
        case searchText(String)
        case searchSuggestions([String])
        case history([(searchText: String, category: [String])])
        case categories([(category: SearchVideoCategoryCellModel, isSelected: Bool)])
    }
    
    let initialize = PublishSubject<Void>()
    let categoryDidTap = PublishSubject<String>()
    let historyDidTap = PublishSubject<[Option]>()
    let inputSearchKeyword: Variable<String?> = .init(nil)
    let searchDidTap = PublishSubject<Void>()
    
    let dataSource: Driver<[SearchViewModel.DataSource]>
    let cancel: Driver<Void>
    let search: Driver<[Option]>
    
    init(service: YoutubeServiceType) {
        dataSource = Driver.empty()
        cancel = Driver.empty()
        search = Driver.empty()
    }
}
