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
    
    var profileJson:JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(cookieManager.isUserCookieSet(forKey: "User-Cookie")){
            let headers: HTTPHeaders = [
                "Set-Cookie":cookieManager.getUserCookie(forKey: "User-Cookie")!,
                "Accept": "application/json"
            ]
            AF.request(Urls.getUserInfo, headers: headers).responseJSON { response in
                switch(response.result) {
                case .success(let data):
                    let json = JSON(data)
                    DispatchQueue.main.async{
                       self.profileJson = json
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
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
    }
    
}

