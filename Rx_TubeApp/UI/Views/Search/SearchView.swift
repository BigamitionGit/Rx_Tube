//
//  SearchView.swift
//  Rx_TubeApp
//
//  Created by 細田　大志 on 2017/07/26.
//  Copyright © 2017 HIroshi Hosoda. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchView: UIView {
    
    let disposeBag = DisposeBag()
    
    init(viewModel: SearchViewModelType) {
        super.init(frame: CGRect.zero)
        
        let searchButton = UIButton()
        let searchBar = UISearchBar()
        
        viewModel.initialize.onNext(Void())
        
        searchBar.rx.text
            .bind(to: viewModel.inputSearchKeyword)
            .disposed(by: disposeBag)
        
        Observable
            .of(searchBar.rx.searchButtonClicked, searchButton.rx.tap)
            .merge()
            .bind(to: viewModel.searchDidTap)
            .disposed(by: disposeBag)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
