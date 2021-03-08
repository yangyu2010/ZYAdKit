//
//  PlaceholderViewController.swift
//  Alamofire
//
//  Created by Yu Yang on 2020/9/21.
//

import UIKit
import GoogleMobileAds
import Kingfisher

@objcMembers class PlaceholderViewController: UIViewController {

    var customView: UIView!
    var adConfig: AdConfig?
    var adInfo: [String: Any]?

    private var interstitial: GADInterstitial!
    private var current_splash_index = 0

    deinit {
        print("deinit called233223")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let customView = customView else {
            back()
            return
        }

        customView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(customView)
        customView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        customView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        customView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        customView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        guard let adInfo = adInfo,
            let type = adInfo["type"] as? Int
            else {
                back()
                return
        }

        if type == 1 {
            // 自定义广告
            guard let source = adInfo["source"] as? [[String: Any]] else {
                back()
                return
            }
            self.loadCustomAd(with: source)

        } else if type == 2 {
            // admob
            guard let source = adInfo["source"] as? [String: Any],
                let key = source["key"] as? String else {
                back()
                return
            }
            self.loadGoogleAd(with: key)
        } else {
            back()
            return
        }
    }
    
    
    /**
     
     ["config": {
         advert =     {
             "\U5f00\U5c4f\U9875\U5e7f\U544a" =         (
                             {
                     category = 1;
                     id = 5;
                     interval = 0;
                     source =                 {
                         key = "ca-app-pub-3940256099942544/4411468910";
                     };
                     type = 2;
                 }
             );
         };
     }, "ok": 1]

     */
    
    private func loadCustomAd(with source: [[String: Any]]) {
        
        // 判断当前显示第几个
        var splashConfig = [String: Any]()
        if let splashConfigTemp = UserDefaults.standard.value(forKey: "kAdSplashInfo") as? [String: Any] {
            splashConfig = splashConfigTemp
            
            if let index = splashConfig["index"] as? Int {
                current_splash_index = index
            }
        } else {
            
        }
        
        // 3
        // 0 1 2 3
        if current_splash_index >= source.count {
            current_splash_index = 0
            
            splashConfig["index"] = current_splash_index
            UserDefaults.standard.setValue(splashConfig, forKey: "kAdSplashInfo")
        }
        
        let ad = source[current_splash_index]
        if let urlString = ad["url"] as? String,
            let link = ad["link"] as? String {
            adConfig?.url = urlString
            adConfig?.link = link
            
            // 更新index
            current_splash_index += 1
            splashConfig["index"] = current_splash_index
            UserDefaults.standard.setValue(splashConfig, forKey: "kAdSplashInfo")
            
            let cached = ImageCache.default.isCached(forKey: urlString)
            if cached == false {
                if let url = URL(string: urlString) {
                    KingfisherManager.shared.retrieveImage(with: url) { (result) in
                        
                    }
                }
                back()
                return
            }
            
            let podBundle = Bundle(for: Self.self)
            let path = podBundle.path(forResource: "ZYAdKit", ofType: "bundle")!
            let bundle = Bundle(path: path)
            let sb = UIStoryboard(name: "ZYAdKit", bundle: bundle)
            if let splash = sb.instantiateViewController(withIdentifier: "CustomSplashController") as? CustomSplashController {
                splash.modalPresentationStyle = .fullScreen
                splash.adConfig = adConfig

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    if let topVc = UIApplication.topViewController() {
                        topVc.present(splash, animated: false, completion: nil)
                    }
                }
            }
        }
    }
    
    private func loadGoogleAd(with key: String) {
        
        interstitial = GADInterstitial(adUnitID: key)
        let request = GADRequest()
        interstitial.load(request)
        interstitial.delegate = self
        
        self.perform(#selector(cancel), with: nil, afterDelay: 5)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            if self.interstitial.isReady {
//                self.interstitial.present(fromRootViewController: self)
//            } else {
//              print("Ad wasn't ready")
//            }
//        }
    }
    
    @objc private func cancel() {
        interstitial = nil
        self.back()
    }
    
    private func back() {

        if let viewController = UIApplication.shared.windows.first!.rootViewController {
            if viewController is PlaceholderViewController {
                let rootVc = adConfig!.rootViewController
                UIApplication.shared.windows.first!.rootViewController = rootVc
            } else {
                DispatchQueue.main.async {
                    self.dismiss(animated: false, completion: nil)
                }
            }
        }
        
    }
}

extension PlaceholderViewController: GADInterstitialDelegate {
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.back()
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        if self.presentedViewController != nil {
            self.presentedViewController?.dismiss(animated: false, completion: {
            })
        } else {
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            ad.present(fromRootViewController: self)
        }
    }
    
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
//        print("interstitialWillDismissScreen 1111")
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
//        print("interstitialDidDismissScreen 222")
        self.back()
    }
    
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        self.back()
    }
    
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
//        print("interstitialWillLeaveApplication 3333")
        self.back()
        UserDefaults.standard.setValue(true, forKey: "kAdSkipOne")
        UserDefaults.standard.synchronize()
    }
}
