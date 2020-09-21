//
//  PlaceholderViewController.swift
//  Alamofire
//
//  Created by Yu Yang on 2020/9/21.
//

import UIKit

class PlaceholderViewController: UIViewController {

    var customView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        debugPrint("PlaceholderViewController viewDidLoad")
        
        customView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(customView)
        customView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        customView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        customView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        customView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true


        AdManager.shared.showSplashAd()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
