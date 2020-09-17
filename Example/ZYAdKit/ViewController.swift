//
//  ViewController.swift
//  ZYAdKit
//
//  Created by Yu Yang on 09/17/2020.
//  Copyright (c) 2020 Yu Yang. All rights reserved.
//

import UIKit
import ZYAdKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let config = AdConfig()
        config.title = "抖音"
        config.subTitle = "抖音抖音 抖音抖音"
        config.icon = UIImage(named: "launch_icon")
        
        AdManager.shared.showSplashAd(with: config)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

