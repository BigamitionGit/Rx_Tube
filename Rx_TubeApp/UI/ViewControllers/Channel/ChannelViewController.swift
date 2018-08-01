//
//  ChannelViewController.swift
//  Rx_TubeApp
//
//  Created by 細田　大志 on 2017/10/06.
//  Copyright © 2017 HIroshi Hosoda. All rights reserved.
//

import UIKit

final class ChannelViewController: UIViewController {
    
    // MARK: Initializing
    
    init(viewModel: ChannelViewModelType) {
        super.init(nibName: nil, bundle: nil)
        self.configure(viewModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: Private Methods
    
    private func configure(_ viewModel: ChannelViewModelType) {
        
    }
}
