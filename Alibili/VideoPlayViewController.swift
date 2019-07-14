/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 A view controller that demonstrates how to present an `AVPlayerViewController` for an `AVPlayerItem` with metadata and timings.
 */

import UIKit
import AVKit
import Alamofire
import SwiftyJSON

class VideoPlayerViewController: UIViewController {
    
    @IBOutlet var playerView: UIView!
    
    private let cookieManager:CookieManager = CookieManager()
    var videoJson:DataItem!
    let player:VLCMediaPlayer = VLCMediaPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItemData(avId: videoJson.id, pageNum: 1)
    }
    
    override func viewWillAppear(_ animated: Bool){
        
        
    }
    
    func loadItemData(avId:String,pageNum:Int) -> Void {
        let headers: HTTPHeaders = [
            "Set-Cookie":cookieManager.getUserCookie(forKey: "User-Cookie")!,
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3260.2 Safari/537.36"
        ]
        AF.request("https://api.bilibili.com/x/web-interface/view?aid=\(avId)").responseJSON { response in
            switch(response.result) {
            case .success(let data):
                let json = JSON(data)
                //                print(json)
                AF.request("https://api.bilibili.com/x/player/playurl?avid=\(avId)&cid=\(json["data"]["cid"].stringValue)&qn=80&type=&fnver=0&fnval=16&otype=json")
                    .responseJSON  { response in
                        switch(response.result) {
                        case .success(let data):
                            let json = JSON(data)
                            var max = 0
                            for data in json["data"]["dash"]["video"].arrayValue {
                                if data["id"].intValue > max && data["id"].intValue <= 80 {
                                    max = data["id"].intValue
                                }
                            }
                            var videoArray = json["data"]["dash"]["video"].arrayValue.filter {$0["id"].intValue == max }
                            print(max)
                            let video = videoArray[0]["base_url"].stringValue
                            let audio = json["data"]["dash"]["audio"][0]["baseUrl"].stringValue
                            let videoMedia = VLCMedia(url: URL(string: video)!)
                            self.player.media = videoMedia
                            self.player.addPlaybackSlave(URL(string: audio)!, type: VLCMediaPlaybackSlaveType.audio, enforce: true)
                            self.player.drawable = self.playerView
                            self.player.play()
                            return
                            //                            do {
                            //                                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                            //                                try AVAudioSession.sharedInstance().setActive(true)
                            //
                            //                                let player = try AVAudioPlayerNode()
                            //
                            //                                player.play()
                            //
                            //                            } catch let error {
                            //                                print(error.localizedDescription)
                            //                            }
                            
                            
                            //                            let headersForVideo: HTTPHeaders = [
                            //                                "Set-Cookie":self.cookieManager.getUserCookie(forKey: "User-Cookie")!,
                            //                                "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3260.2 Safari/537.36",
                            //                                "Referer":"https://www.bilibili.com/video/av\(avId)",
                            //                                "Origin":"https://www.bilibili.com",
                            //                                "Accept":"*/*",
                            //                                "Accept-Encoding":"gzip, deflate, sdch, br",
                            //                                "Accept-Language":"zh-CN,zh;q=0.8"
                            //                            ]
                            //
                            //                            AF.request(dataarray[0]["base_url"].stringValue, headers: headersForVideo).response { response in
                            //                                print(response.debugDescription)
                            //                            }
                            
                            let player = AVPlayer(url: URL(string: video)!)
                            let playerViewController = AVPlayerViewController()
                            playerViewController.player = player
                            
                            self.present(playerViewController, animated: true) {
                                player.play()
                            }
                            
                            
                            
                        case .failure(let error):
                            print(error)
                            break
                        }
                        
                }
                
            case .failure(let error):
                print(error)
                break
            }
            
        }
        
    }
}
