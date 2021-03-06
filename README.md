# ZYAdKit

[![CI Status](https://img.shields.io/travis/Yu Yang/ZYAdKit.svg?style=flat)](https://travis-ci.org/Yu Yang/ZYAdKit)
[![Version](https://img.shields.io/cocoapods/v/ZYAdKit.svg?style=flat)](https://cocoapods.org/pods/ZYAdKit)
[![License](https://img.shields.io/cocoapods/l/ZYAdKit.svg?style=flat)](https://cocoapods.org/pods/ZYAdKit)
[![Platform](https://img.shields.io/cocoapods/p/ZYAdKit.svg?style=flat)](https://cocoapods.org/pods/ZYAdKit)

##1.从后台读取配置
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[ServiceApi getConfig];
}
```

![](Xnip2020-11-17_10-58-39.jpg)

```
UserDefaults.standard.setValue(json, forKey: "kAdInfo")
UserDefaults.standard.synchronize()

AdManager.shared.cacheDatas()
```


##2.设置config

![图1](Xnip2020-09-24_11-56-53.jpg)

- 1. 先设置config, 把要显示的`rootViewController`传过去
- 2. 加载假的`launchView`, 和真的`launchView`一摸一样的	`view`, 如上图
- 3. 获取占位的VC显示
- 4. 未获取到, 则加载自己的`rootViewController`

```
let config = AdConfig()
let storyboard = UIStoryboard(name: "Main", bundle: nil)
let mainVc = storyboard.instantiateInitialViewController()!
config.rootViewController = mainVc
AdManager.shared.setConfig(config)


let placeholderLaunchView = Bundle.main.loadNibNamed("PlaceholderLaunchView", owner: nil, options: nil)?.first as! UIView
        
if let placeholderLaunchVc = AdManager.shared.getPlaceholderViewController(with: placeholderLaunchView) {
	window = UIWindow(frame: UIScreen.main.bounds)
	window?.rootViewController = placeholderLaunchVc
} else {
	window = UIWindow(frame: UIScreen.main.bounds)
	window?.rootViewController = mainVc
}
window?.makeKeyAndVisible()

```


##3.在 info.plist 里设置admob key
```
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-3940256099942544~1458002511</string>
```


注意项
##1. `Main Interface` 要清空, 从代码加载
![图1](Xnip2020-09-24_18-04-49.jpg)
