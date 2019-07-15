//
//  HomeViewController.swift
//  Alibili
//
//  Created by Xiaonan Zhang on 2019/07/07.
//  Copyright © 2019 Xiaonan Zhang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProfileViewController: UIViewController {

    let segueIdentifier:String = "profileMenuTableSegueIdentifier"
    
    let cookieManager = CookieManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(cookieManager.isUserCookieSet(forKey: "User-Cookie")){
            let headers: HTTPHeaders = [
                "Set-Cookie":cookieManager.getUserCookie(forKey: "User-Cookie")!,
                "Accept": "application/json"
            ]
            AF.request("https://api.live.bilibili.com/User/getUserInfo", headers: headers).responseJSON { response in
                switch(response.result) {
                case .success(let data):
                    let json = JSON(data)
                    DispatchQueue.main.async{
                        print(json)
                    }
                case .failure(let error):
                    print(error)
                    break
                }
            }
            
        }
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
//        if (segue.identifier == segueIdentifier) {
//            let menuViewController = segue.destination as! MenuTableViewController
//            // Now you have a pointer to the child view controller.
//            // You can save the reference to it, or pass data to it.
//        }
    }
    
}

