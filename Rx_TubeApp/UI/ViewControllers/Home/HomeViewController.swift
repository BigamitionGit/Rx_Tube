//
//  HomeViewController.swift
//  Rx_TubeApp
//
//  Created by 細田大志 on 2018/10/31.
//  Copyright © 2018 HIroshi Hosoda. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    // MARK: Initializing
    
    init(viewModel: HomeViewModelType) {
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}
