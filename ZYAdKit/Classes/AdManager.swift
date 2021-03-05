//
//  AdManager.swift
//  Pods-ZYAdKit_Example
//
//  Created by Yu Yang on 2020/9/17.
//

import UIKit
import Kingfisher
import GoogleMobileAds

@objcMembers public class AdManager: NSObject {
    public static let shared = AdManager()
    private var adConfig: AdConfig?
    private var adInfo: [String: Any]?
    private var customView: UIView?
    private var isVip: Bool = false
    
    public func setConfig(_ config: AdConfig) {
        adConfig = config
        
        // 获取本地配置
        guard let info = UserDefaults.standard.value(forKey: "kAdInfo") as? [String: Any] else { return }
        guard let config = info["config"] as? [String: Any] else { return }
        guard let advert = config["advert"] as? [String: Any] else { return }
        guard let splashInfo = advert["开屏页广告"] as? [[String: Any]] else { return }
        
        // 取出第一个可用的广告
        for item in splashInfo {
            if let status = item["status"] as? Int, status == 0 {
                adInfo = item
                break
            }
        }
    }
    
    @discardableResult
    public func getPlaceholderViewController(with customView: UIView) -> UIViewController? {
        self.customView = customView

        guard adInfo != nil else { return nil }
        
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
    
    public func clearCache() {
        isVip = true
    }
    
    public func cacheDatas() {
        guard let info = UserDefaults.standard.value(forKey: "kAdInfo") as? [String: Any] else { return }
        guard let config = info["config"] as? [String: Any] else { return }
        guard let advert = config["advert"] as? [String: Any] else { return }
        guard let splashInfo = advert["开屏页广告"] as? [[String: Any]] else { return }
        
        // 取出第一个可用的广告
        for item in splashInfo {
            if let status = item["status"] as? Int, status == 0 {
                adInfo = item
                break
            }
        }
        
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
    
    private override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationBecomeActive), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private func applicationBecomeActive() {
        guard adInfo != nil else { return }
        guard isVip == false else { return }
        
        if UserDefaults.standard.bool(forKey: "kAdSkipOne") == true {
            UserDefaults.standard.setValue(false, forKey: "kAdSkipOne")
            return
        }
        
        let podBundle = Bundle(for: Self.self)
        let path = podBundle.path(forResource: "ZYAdKit", ofType: "bundle")!
        let bundle = Bundle(path: path)
        let sb = UIStoryboard(name: "ZYAdKit", bundle: bundle)

        /// 当前顶部控制器是广告时 不再叠加
        // NSStringFromClass(topVc.classForCoder) != "GADFullScreenAdViewController",

        if let topVc = UIApplication.topViewController(),
           NSStringFromClass(topVc.classForCoder) != "GADFullScreenAdViewController",
            let vc = sb.instantiateViewController(withIdentifier: "PlaceholderViewController") as? PlaceholderViewController {

            vc.customView = customView
            vc.adConfig = adConfig
            vc.adInfo = adInfo
            vc.modalPresentationStyle = .fullScreen
            
            DispatchQueue.main.async {
                topVc.present(vc, animated: false, completion: nil)
            }
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
