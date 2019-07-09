//
//  PrivateNavigationController.swift
//  Alibili
//
//  Created by Xiaonan Zhang on 2019/07/08.
//  Copyright © 2019 Xiaonan Zhang. All rights reserved.
//

import Foundation
import UIKit

class RootViewNavigator {
    let cookieManager = CookieManager()
    func updateRootViewController(){
        var rootVC : UIViewController?
        if(cookieManager.isUserCookieSet(forKey: "User-Cookie")){
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home") as! UITabBarController
        }else{
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "login") as! LoginViewController
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC
    }
    
}
