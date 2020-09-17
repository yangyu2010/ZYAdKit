//
//  CustomSplashController.swift
//  Pods-ZYAdKit_Example
//
//  Created by Yu Yang on 2020/9/17.
//

import UIKit
import Kingfisher

class CustomSplashController: UIViewController {

    @IBOutlet private weak var imgView: UIImageView!
    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblSubTitle: UILabel!
    @IBOutlet private weak var viewSkip: UIView!
    @IBOutlet private weak var lblCountDown: UILabel!
    
    var adConfig: AdConfig?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        lblSubTitle.text = "addd"
        
        guard let adConfig = adConfig else { return }
        self.iconView.image = adConfig.icon!
        self.lblTitle.text = adConfig.title!
        self.lblSubTitle.text = adConfig.subTitle!
        
        self.imgView.kf.setImage(with: URL(string: adConfig.url!))
        
        
//        print(adConfig.)
        
    }

    
    

}
