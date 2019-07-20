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
import SWXMLHash

class VideoPlayerViewController: UIViewController, BarrageRendererDelegate {
    
    @IBOutlet var playerView: UIView!
    
    private let cookieManager:CookieManager = CookieManager()
    var videoJson:SubscriptionsCellDataItem!
    let player:VLCMediaPlayer = VLCMediaPlayer()
    var _index:Int = 0
    
    var timer:Timer!
    var barrageRenderer:BarrageRenderer!
    var danmuReady:Bool = false
    var danmuList:[CUnsignedLongLong : [DanmuData]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData(avId: videoJson.id, pageNum: 1)
    }
    
    func walkTextSpriteDescriptorWithDirection(direction:UInt) -> BarrageDescriptor{
        let descriptor:BarrageDescriptor = BarrageDescriptor()
        descriptor.spriteName = NSStringFromClass(BarrageWalkTextSprite.self)
        descriptor.params["text"] = "dadadadada"
        descriptor.params["textColor"] = UIColor.white
        descriptor.params["speed"] = 100
        descriptor.params["direction"] = direction
        return descriptor
    }
    
    @objc func autoSenderBarrage() {
        let spriteNumber :NSInteger = barrageRenderer.spritesNumber(withName: nil)
        print("adadad")
        if spriteNumber <= 50 {
            barrageRenderer.receive(walkTextSpriteDescriptorWithDirection(direction: BarrageWalkDirection.R2L.rawValue))
        }
    }
    
    func configDanMu() {
        barrageRenderer = BarrageRenderer.init()
        barrageRenderer.canvasMargin = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        playerView.addSubview(barrageRenderer.view)
        barrageRenderer.start()
        
        autoSenderBarrage()
        autoSenderBarrage()
        autoSenderBarrage()
        autoSenderBarrage()
        // 这两句相信你看的懂
//        let safeObj = NSSafeObject.init(object: self, with: #selector(self.autoSenderBarrage))
//        timer = Timer.scheduledTimer(timeInterval: 0.5, target: safeObj as Any, selector: #selector(NSSafeObject.excute), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool){
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        barrageRenderer.stop()
    }
    
    func loadDanmuData(cid:String) -> Void {
        print("https://api.bilibili.com/x/v1/dm/list.so?oid=\(cid)")
        AF.request("https://api.bilibili.com/x/v1/dm/list.so?oid=\(cid)").responseString(encoding: String.Encoding.utf8) { response in
            var statusCode = response.response?.statusCode
            switch response.result {
                case .success:
                    print("status code is: \(String(describing: statusCode))")
                    if let string = response.value {
                        let xml = SWXMLHash.parse(string)
                        for elem in xml["i"]["d"].all {
                            let danmu = DanmuData(elem: elem)
                            if var dictValue = self.danmuList[danmu.timing] {
                                dictValue.append(danmu)
                            } else {
                                self.danmuList[danmu.timing] = [danmu]
                            }
                           
                        }
                        print(self.danmuList)
                    }
                case .failure(let error):
                    statusCode = error._code // statusCode private
                    print("status code is: \(String(describing: statusCode))")
                    print(error)
            }
            self.danmuReady = true
        }
    }
    
    func loadMediaData(avId:String,cid:String) -> Void {
        AF.request("https://api.bilibili.com/x/player/playurl?avid=\(avId)&cid=\(cid)&qn=80&type=&fnver=0&fnval=16&otype=json")
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
                    let video = videoArray[0]["base_url"].stringValue
                    let audio = json["data"]["dash"]["audio"][0]["baseUrl"].stringValue
                    let videoMedia = VLCMedia(url: URL(string: video)!)
                    self.player.media = videoMedia
                    self.player.addPlaybackSlave(URL(string: audio)!, type: VLCMediaPlaybackSlaveType.audio, enforce: true)
                    self.player.drawable = self.playerView
                    
                    self.loadDanmuData(cid:cid)
                    //                    while(self.danmuReady != true){
                    //                        self.loadDanmuData(cid:cid)
                    //                    }
                    self.configDanMu()
                    
                    self.player.play()
                    return
                case .failure(let error):
                    print(error)
                    break
                }
            }
    }
    
    func loadData(avId:String,pageNum:Int) -> Void {
        AF.request("https://api.bilibili.com/x/web-interface/view?aid=\(avId)").responseJSON { response in
            switch(response.result) {
                case .success(let data):
                    let json = JSON(data)
                    let cid = json["data"]["cid"].stringValue
                    self.loadMediaData(avId: avId, cid: cid)
                
                case .failure(let error):
                    print(error)
                    break
                }
            
        }
        
    }
}
