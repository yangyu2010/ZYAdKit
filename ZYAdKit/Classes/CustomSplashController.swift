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
    
    private var timer: Timer!
    private var currentCount = 5
    
    deinit {
        debugPrint("CustomSplashController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let adConfig = adConfig else { return }
        self.iconView.image = adConfig.icon!
        self.lblTitle.text = adConfig.title!
        self.lblSubTitle.text = adConfig.subTitle!
        self.imgView.kf.setImage(with: URL(string: adConfig.url!))
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (Timer) in
            if self.currentCount <= 1 {
                Timer.invalidate()
                self.dismiss(animated: false, completion: nil)
            } else {
                self.currentCount -= 1
                self.lblCountDown.text = "\(self.currentCount)s"
            }
        }
    }
    
    @IBAction func skip(_ sender: Any) {
        timer.invalidate()
        self.dismiss(animated: false, completion: nil)
    }
    
}
