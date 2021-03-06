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
//        self.iconView.image = adConfig.icon!
//        self.lblTitle.text = adConfig.title!
//        self.lblSubTitle.text = adConfig.subTitle!
        self.imgView.kf.setImage(with: URL(string: adConfig.url!))
        self.imgView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(jump))
        self.imgView.addGestureRecognizer(tap)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
            if self.currentCount <= 1 {
                self.back()
            } else {
                self.currentCount -= 1
                self.lblCountDown.text = "\(self.currentCount)s"
            }
        }
    }
    
    @IBAction func skip(_ sender: Any) {
        self.back()
    }
    
    @objc private func jump() {
        guard let link = adConfig?.link,
            let url = URL(string: link) else { return }
        self.back()
        UserDefaults.standard.setValue(true, forKey: "kAdSkipOne")
        UserDefaults.standard.synchronize()
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func back() {
        timer.invalidate()

        if let viewController = UIApplication.shared.windows.first!.rootViewController {
            if viewController is PlaceholderViewController {
                let rootVc = adConfig!.rootViewController
                UIApplication.shared.windows.first!.rootViewController = rootVc
            } else {
                
                var vc : UIViewController = self
                while((vc.presentingViewController) != nil) {
                    vc = vc.presentingViewController!;
                }
                vc.dismiss(animated: false, completion: nil)
                
            }
        }
        
    }
}
