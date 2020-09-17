//
//  AdManager.swift
//  Pods-ZYAdKit_Example
//
//  Created by Yu Yang on 2020/9/17.
//

import UIKit

public class AdManager {
    public static let shared = AdManager()

    public func showSplashAd(with adConfig: AdConfig) {
        // 读取本地配置
        // 判断是否可以显示
        // 判断是admob还是自定义广告
        
        guard let info = UserDefaults.standard.value(forKey: "kAdInfo") as? [String: Any] else { return }
        guard let config = info["config"] as? [String: Any] else { return }
        guard let advert = config["advert"] as? [String: Any] else { return }
        
        if let splashInfo = advert["开屏页广告"] as? [[String: Any]],
            let firstAd = splashInfo.first {
            guard let type = firstAd["type"] as? Int else { return }
            if type == 1 {
                // 自定义广告
                if let source = firstAd["source"] as? [[String: Any]],
                    let first = source.first,
                    let url = first["url"] as? String,
                    let link = first["link"] as? String {
                    adConfig.url = url
                    adConfig.link = link
                 
                    let sb = UIStoryboard(name: "AdKit", bundle: Bundle(for: Self.self))
                    if let splash = sb.instantiateViewController(withIdentifier: "CustomSplashController") as? CustomSplashController {
                        splash.modalPresentationStyle = .fullScreen
                        splash.adConfig = adConfig
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            if let topVc = UIApplication.topViewController() {
                                topVc.present(splash, animated: false, completion: nil)
                            }
                        }
                        DispatchQueue.main.async {
                            
                        }
                    }                    
                }
            } else if type == 2 {
                
            } else {
                return
            }
        }
    }
    
    private init() {
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
