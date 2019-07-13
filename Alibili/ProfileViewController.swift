//
//  HomeViewController.swift
//  Alibili
//
//  Created by Xiaonan Zhang on 2019/07/07.
//  Copyright © 2019 Xiaonan Zhang. All rights reserved.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController {

    let cookieManager = CookieManager()
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        logoutButton.setTitle("Log out", for: .normal)
        
        if(cookieManager.isUserCookieSet(forKey: "User-Cookie")){
            let headers: HTTPHeaders = [
                "Set-Cookie":cookieManager.getUserCookie(forKey: "User-Cookie")!,
                "Accept": "application/json"
            ]
            AF.request("https://api.live.bilibili.com/User/getUserInfo", headers: headers).responseJSON { response in
//                print("Result: \(response.result)")
            }
            
        }
        
    }
    
    @IBAction func onLogout(_ sender: Any, forEvent event: UIEvent) {
                print(sender)
        cookieManager.removeUserCookie(forKey: "User-Cookie")
        RootViewNavigator().updateRootViewController()
        //        print(event)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

//        if(cookieManager.isUserCookieSet(forKey: "User-Cookie")){
//            let headers: HTTPHeaders = [
//                "Set-Cookie":cookieManager.getUserCookie(forKey: "User-Cookie")!,
//                "Accept": "application/json"
//            ]
//            AF.request("https://api.live.bilibili.com/User/getUserInfo", headers: headers).responseJSON { response in
////                    print("Result: \(response.result)")   
//                }
//
//        }
//        else{
//            let destinationController = storyboard!.instantiateViewController(withIdentifier: "login")
//            present(destinationController, animated: true, completion: nil)
//        }
        
    }
    
}

