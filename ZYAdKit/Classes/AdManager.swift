//
//  AdManager.swift
//  Pods-ZYAdKit_Example
//
//  Created by Yu Yang on 2020/9/17.
//

import UIKit
import Kingfisher

public class AdManager {
    public static let shared = AdManager()
    private var adConfig: AdConfig?
    private var adInfo: [String: Any]?
//    private var current_splash_index = 0
    private var customView: UIView?
    
    public func setConfig(_ config: AdConfig) {
        adConfig = config
        
        // 获取本地配置
        guard let info = UserDefaults.standard.value(forKey: "kAdInfo") as? [String: Any] else { return }
        guard let config = info["config"] as? [String: Any] else { return }
        guard let advert = config["advert"] as? [String: Any] else { return }
        adInfo = advert
        
    }
    
    public func getPlaceholderViewController(with customView: UIView) -> UIViewController? {
        guard adInfo != nil else { return nil }
        self.customView = customView
        
        let podBundle = Bundle(for: Self.self)
        let path = podBundle.path(forResource: "ZYAdKit", ofType: "bundle")!
        let bundle = Bundle(path: path)
        let sb = UIStoryboard(name: "ZYAdKit", bundle: bundle)
        if let vc = sb.instantiateViewController(withIdentifier: "PlaceholderViewController") as? PlaceholderViewController {            
            vc.customView = customView
            vc.adConfig = adConfig
            vc.adInfo = adInfo
            return vc
        }
        
        return nil
    }
    
//    public func showSplashAd() {
//        // 读取本地配置
//        // 判断是否可以显示
//        // 判断是admob还是自定义广告
//
//        guard let adConfig = adConfig else { return }
//        guard let adInfo = adInfo else { return }
//        guard let splashInfo = adInfo["开屏页广告"] as? [[String: Any]] else { return }
//
//        guard let firstAd = splashInfo.first else { return }
//        guard let source = firstAd["source"] as? [[String: Any]] else { return }
//
//        // 判断当前显示第几个
//        var splashConfig = [String: Any]()
//        if let splashConfigTemp = UserDefaults.standard.value(forKey: "kAdSplashInfo") as? [String: Any] {
//            splashConfig = splashConfigTemp
//
//            if let index = splashConfig["index"] as? Int {
//                current_splash_index = index
//            }
//        } else {
//
//        }
//
//        // 3
//        // 0 1 2 3
//        if current_splash_index >= source.count {
//            current_splash_index = 0
//
//            splashConfig["index"] = current_splash_index
//            UserDefaults.standard.setValue(splashConfig, forKey: "kAdSplashInfo")
//        }
//
//        let ad = source[current_splash_index]
//        if let url = ad["url"] as? String,
//            let link = ad["link"] as? String {
//            adConfig.url = url
//            adConfig.link = link
//
//            // 更新index
//            current_splash_index += 1
//            splashConfig["index"] = current_splash_index
//            UserDefaults.standard.setValue(splashConfig, forKey: "kAdSplashInfo")
//
//            let sb = UIStoryboard(name: "AdKit", bundle: Bundle(for: Self.self))
//            if let splash = sb.instantiateViewController(withIdentifier: "CustomSplashController") as? CustomSplashController {
//                splash.modalPresentationStyle = .fullScreen
//                splash.adConfig = adConfig
//
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                    if let topVc = UIApplication.topViewController() {
//                        topVc.present(splash, animated: false, completion: nil)
//                    }
//                }
//            }
//        }
//    }
    
    public func cacheDatas() {
        guard let info = UserDefaults.standard.value(forKey: "kAdInfo") as? [String: Any] else { return }
        guard let config = info["config"] as? [String: Any] else { return }
        guard let advert = config["advert"] as? [String: Any] else { return }
        adInfo = advert
        
        guard let splashInfo = advert["开屏页广告"] as? [[String: Any]] else { return }
        for item in splashInfo {
            if let source = item["source"] as? [[String: Any]] {
                for adDict in source {
                    if let urlString = adDict["url"] as? String,
                        let url = URL(string: urlString) {
                        KingfisherManager.shared.retrieveImage(with: url) { (result) in
                            
                        }
                    }
                }
            }
        }
        
    }
    
    private init() {

        NotificationCenter.default.addObserver(self, selector: #selector(applicationBecomeActive), name: UIApplication.willEnterForegroundNotification, object: nil)
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];

    }
    
    @objc private func applicationBecomeActive() {
        
        let podBundle = Bundle(for: Self.self)
        let path = podBundle.path(forResource: "ZYAdKit", ofType: "bundle")!
        let bundle = Bundle(path: path)
        let sb = UIStoryboard(name: "ZYAdKit", bundle: bundle)
        if let vc = sb.instantiateViewController(withIdentifier: "PlaceholderViewController") as? PlaceholderViewController {
            vc.customView = customView
            vc.adConfig = adConfig
            vc.adInfo = adInfo
        }

        
        if let topVc = UIApplication.topViewController(),
            let vc = sb.instantiateViewController(withIdentifier: "PlaceholderViewController") as? PlaceholderViewController {

            vc.customView = customView
            vc.adConfig = adConfig
            vc.adInfo = adInfo
            vc.modalPresentationStyle = .fullScreen
            
            topVc.present(vc, animated: false, completion: nil)
        }
    }
}



extension UIApplication {
    class func topViewController(base: UIViewController? = (UIApplication.shared.delegate)?.window??.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
