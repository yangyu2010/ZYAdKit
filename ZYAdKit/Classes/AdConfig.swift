//
//  AdConfig.swift
//  Pods-ZYAdKit_Example
//
//  Created by Yu Yang on 2020/9/17.
//

import UIKit

@objcMembers public class AdConfig: NSObject {
//    public var title: String!
//    public var subTitle: String!
//    public var icon: UIImage?
    public var rootViewController: UIViewController!
    
    public var duration = 5
    public var showSkipButton = true
    
    public var link: String?
    public var url: String?
    
    public override init() {
    
    }
}
