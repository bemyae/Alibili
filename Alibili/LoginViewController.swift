//
//  LoginViewController.swift
//  Alibili
//
//  Created by Xiaonan Zhang on 2019/07/07.
//  Copyright © 2019 Xiaonan Zhang. All rights reserved.
//

import UIKit
import Alamofire
import Foundation


class LoginViewController: UIViewController {

    @IBOutlet weak var qrcodeImageView: UIImageView!
    let cookieManager = CookieManager()
    var currentLevel:Int = 0, finalLevel:Int = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startValidation()
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
    func startValidation() -> Void {
        AF.request("https://passport.bilibili.com/qrcode/getLoginUrl").responseJSON { response in
            switch(response.result) {
                case .success(let data):
                    if let dictionary = data as? [String: Any] {
                        if let nestedDictionary = dictionary["data"] as? [String: Any] {
                            if let url = nestedDictionary["url"] as? String {
                                DispatchQueue.main.async {
                                    self.qrcodeImageView.image = self.generateQRCode(from: url)
                                }
                            }
                            if let oauthKey = nestedDictionary["oauthKey"] as? String {
                                self.loopValidation(oauthKey: oauthKey)
                            }
                        }
                    }
                case .failure(let error):
                    print("------loopValidation---------")
                    break
            }
        }
    }
    
    func loopValidation(oauthKey: String) -> Void{
       
        DispatchQueue.global(qos: .background).async {
            // You are now running on the concurrent `queue` you created earlier.
            print("Parsing JSON on thread: \(Thread.current) is main thread: \(Thread.isMainThread)")
            while (self.currentLevel < self.finalLevel) {
                sleep(10)
                let headers: HTTPHeaders = [
                    "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
                    "Accept": "application/json"
                ]
                let params:Parameters = [
                    "oauthKey": oauthKey,
                    "gourl":"https://www.bilibili.com/"
                ]
                AF.request("https://passport.bilibili.com/qrcode/getLoginInfo", method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                        switch(response.result) {
                        case .success(let data):
                            if let dictionary = data as? [String: Any] {
                                if let status = dictionary["status"] as? Bool {
                                    if(status){
                                        self.cookieManager.saveUserCookie(forKey: "User-Cookie", response: response.response!)
                                        self.currentLevel = self.finalLevel
                                        DispatchQueue.main.async {
                                            print("Am I back on the main thread: \(Thread.isMainThread)")
//                                            let destinationController = self.storyboard!.instantiateViewController(withIdentifier: "home")
//                                            self.present(destinationController, animated: true, completion: nil)
                                            RootViewNavigator().updateRootViewController()
                                        }
                                    }else{
                                        if let data = dictionary["data"] as? Int {
                                            print(data)
                                            if data == -2{
                                                 self.startValidation()
                                            }
                                        }
                                    }
                                }
                            }
                        case .failure(let error):
                            print("------loopValidation---------")
                            break
                        }
                    }
                self.currentLevel += 1
                print(["success ",self.currentLevel, self.finalLevel, self.currentLevel < self.finalLevel])
            }
            
        }

    }
}
    
//    func loopValidation(oauthKey: String) -> Void{
//        var currentLevel:Int = 0, finalLevel:Int = 1000
//        let queue = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
//        while (currentLevel < finalLevel) {
//                sleep(5)
//                let headers: HTTPHeaders = [
//                    "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
//                    "Accept": "application/json"
//                ]
//                let params:Parameters = [
//                    "oauthKey": oauthKey,
//                    "gourl":"https://www.bilibili.com/"
//                ]
//
//            AF.request("https://passport.bilibili.com/qrcode/getLoginInfo", method: .post, parameters: params, encoding: URLEncoding.default, headers: headers)
//                .responseJSON(
//                    queue: queue,
//                    options: .allowFragments,
//                    completionHandler: { response in
//                    // You are now running on the concurrent `queue` you created earlier.
//                    print("Parsing JSON on thread: \(Thread.current) is main thread: \(Thread.isMainThread)")
//                    // Validate your JSON response and convert into model objects if necessary
////                    print(response.result)
//                    // To update anything on the main thread, just jump back on like so.
//                    switch(response.result) {
//                        case .success(let data):
//                            if let dictionary = data as? [String: Any] {
//                                if let status = dictionary["status"] as? Bool {
//                                    if(status){
//                                        self.cookieManager.saveUserCookie(forKey: "User-Cookie", response: response.response!)
//                                        currentLevel = finalLevel
//                                        DispatchQueue.main.async {
//                                            print("Am I back on the main thread: \(Thread.isMainThread)")
//                                            let destinationController = self.storyboard!.instantiateViewController(withIdentifier: "home")
//                                            self.present(destinationController, animated: true, completion: nil)
//                                        }
//                                    }else{
//                                        if let data = dictionary["data"] as? Int {
//                                            print(data)
//                                        }
//                                    }
//                                }
//                            }
//                        case .failure(let error):
//                            print("------loopValidation---------")
//                            break
//                        }
//                    }
//                )
//
    
        
//                currentLevel += 1
//                print(["success ",currentLevel," ", finalLevel, currentLevel < finalLevel])
//            }
//
//
//    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

