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

class VideoPlayerViewController: UIViewController, BarrageRendererDelegate, VLCMediaPlayerDelegate {
    
    @IBOutlet var playerView: UIView!
    @IBOutlet weak var mediaView: UIView!
    
//    let activityIndicatiorView: UIActivityIndicatorView = {
//        let aiv = UIActivityIndicatorView()
//        aiv.color = .white
//        aiv.translatesAutoresizingMaskIntoConstraints = false
//        aiv.startAnimating()
//        return aiv
//    }()
    var observation: NSKeyValueObservation?
    
    private let cookieManager:CookieManager = CookieManager()
    
    var pageNum:Int = 0
    let player:VLCMediaPlayer = VLCMediaPlayer()
    var videoLength:CUnsignedLongLong = 0
    
    var currentTime:CUnsignedLongLong = 0
    var timer:Timer!
    var barrageRenderer:BarrageRenderer!
    var danmuList:[CUnsignedLongLong : [DanmuData]] = [:]
    
    var videoJson:CellDataItem!
    var videoInfo: JSON = JSON({})
    
    let routePickerView = AVRoutePickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        playerView.addSubview(activityIndicatiorView)
//        activityIndicatiorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        activityIndicatiorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        if videoJson.bangumi.ep_id != -1 && videoJson.videoDetail.videos != 1{
            loadData(avId: videoJson.aid, seasonId: String(videoJson.bangumi.season.season_id), pageNum: pageNum)
        } else {
            loadData(avId: videoJson.aid, pageNum: pageNum)
        }
        routePickerView.isHidden = true
        self.view.addSubview(routePickerView)
        
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeRecognizer.direction = .up
        self.view.addGestureRecognizer(swipeRecognizer)

    }
    
    @objc func swiped(sender: UISwipeGestureRecognizer) {

        if sender.direction == .up {
            if let routePickerButton = routePickerView.subviews.first(where: { $0 is UIButton }) as? UIButton {
                routePickerButton.sendActions(for: .touchUpInside)
            }
        }
            
    }
    
    func walkTextSpriteDescriptorWithDirection(direction:UInt, text:String) -> BarrageDescriptor{
        let descriptor:BarrageDescriptor = BarrageDescriptor()
        descriptor.spriteName = NSStringFromClass(BarrageWalkTextSprite.self)
        descriptor.params["text"] = text
        descriptor.params["textColor"] = UIColor.white
        descriptor.params["fontSize"] = 36;
        descriptor.params["speed"] = Int(arc4random()%50) + 150
        descriptor.params["direction"] = direction
        return descriptor
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {

        for press in presses {
            switch press.type {
            case .playPause:
                if player.isPlaying {
                    player.pause()
                }
                else {
                    player.play()
                }
                
            default: ()
            }
        }
    }
    
    @objc func autoSenderBarrage() {
        let _ :NSInteger = barrageRenderer.spritesNumber(withName: nil)
        if let danmudict = self.danmuList[currentTime] {
            for (index, danmu) in danmudict.enumerated() {
                if index > 5 { break }
                barrageRenderer.receive(walkTextSpriteDescriptorWithDirection(direction: BarrageWalkDirection.R2L.rawValue, text: danmu.text))
            }
        }
        currentTime = currentTime + 1
        if currentTime >= videoLength {
            self.timer?.invalidate()
        }
    }
    
    func configDanMu() {
        barrageRenderer = BarrageRenderer.init()
        barrageRenderer.canvasMargin = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        playerView.insertSubview(barrageRenderer.view, aboveSubview: mediaView)
        barrageRenderer.start()
        
        // 这两句相信你看的懂
        let safeObj = NSSafeObject.init(object: self, with: #selector(self.autoSenderBarrage))
        timer = Timer.scheduledTimer(timeInterval: 1, target: safeObj as Any, selector: #selector(NSSafeObject.excute), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool){
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if barrageRenderer != nil {
            barrageRenderer.stop()
        }
    }
    
    func loadDanmuData(cid:String) -> Void {
        if(cookieManager.isUserCookieSet(forKey: "User-Cookie")){
            let headers: HTTPHeaders = [
                "Set-Cookie":cookieManager.getUserCookie(forKey: "User-Cookie")!,
                "Accept": "application/json"
            ]
            AF.request(Urls.getDanmu(cid: cid), headers: headers).responseString(encoding: String.Encoding.utf8) { response in
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
                                self.danmuList[danmu.timing] = dictValue
                            } else {
                                self.danmuList[danmu.timing] = [danmu]
                            }
                            
                        }
                        self.configDanMu()
                    }
                case .failure(let error):
                    statusCode = error._code // statusCode private
                    print("status code is: \(String(describing: statusCode))")
                    print(error)
                }
            }
        }
    }
    
    func loadMediaData(avId:String,cid:String) throws -> Void {
        if(cookieManager.isUserCookieSet(forKey: "User-Cookie")){
            let headers: HTTPHeaders = [
                "Set-Cookie":cookieManager.getUserCookie(forKey: "User-Cookie")!,
                "Accept": "application/json"
            ]
            AF.request(Urls.getVideoData(avId: avId, cid: cid), headers: headers)
                .responseJSON  { response in
                    switch(response.result) {
                    case .success(let data):
                        do {
                            try self.playmedia(json: JSON(data), avId: avId, cid: cid)
                        } catch let error {
                            print("Can not play. Error: \(error)")
                            if let nav = self.navigationController {
                                nav.popViewController(animated: true)
                            } else {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                        
                        return
                    case .failure(let error):
                        print(error)
                        break
                    }
            }
        }
    }
    
    func playmedia(json: JSON, avId:String, cid:String) throws -> Void {
        var max = 0
        for data in json["data"]["dash"]["video"].arrayValue {
            if data["id"].intValue > max && data["id"].intValue <= 80 {
                max = data["id"].intValue
            }
        }
        let videoArray = json["data"]["dash"]["video"].arrayValue.filter {$0["id"].intValue == max }
        if videoArray.isEmpty {
            throw NSError(domain: "no data", code: -1, userInfo: nil)
        }
        let video = videoArray[0]["base_url"].stringValue
        let audio = json["data"]["dash"]["audio"][0]["baseUrl"].stringValue
        self.videoLength = CUnsignedLongLong(json["data"]["timelength"].rawString()!)!/1000
        let videoMedia = VLCMedia(url: URL(string: video)!)
        videoMedia.addOptions([
            "http-user-agent": "Bilibili Freedoooooom/MarkII",
            "http-referrer": Urls.getHttpReferrer(avId: avId)
        ])
        self.player.media = videoMedia
        self.player.delegate = self
        self.player.addPlaybackSlave(URL(string: audio)!, type: VLCMediaPlaybackSlaveType.audio, enforce: true)
        self.player.drawable = self.mediaView
        
        self.loadDanmuData(cid:cid)
        //                    self.observation = self.player.observe(\.self.isPlaying, options: [.old, .new]){ object, change in
        //                        print("myDate changed from: \(change.oldValue!), updated to: \(change.newValue!)")
        //                    }
        self.player.play()
    }
    
    func mediaPlayerStateChanged(_ aNotification: Notification) {
        let state : VLCMediaPlayerState = player.state
        //        print("mediaPlayerStateChanged \(aNotification) \(state.rawValue)")
        switch state {
        case VLCMediaPlayerState.stopped:
            print("Player has stopped")
//            if let nav = self.navigationController {
//                nav.popViewController(animated: true)
//            } else {
//                self.dismiss(animated: true, completion: nil)
//            }
        case VLCMediaPlayerState.opening:
            print("Stream is opening")
        case VLCMediaPlayerState.buffering:
//            activityIndicatiorView.stopAnimating()
//            playerView.backgroundColor = .clear
            print("Stream is buffering")
        case VLCMediaPlayerState.ended:
            print("Stream has ended")
        case VLCMediaPlayerState.error:
            print("Player has generated an error")
        case VLCMediaPlayerState.playing:
            print("Stream is playing")
        case VLCMediaPlayerState.paused:
            print("Stream is paused")
        case VLCMediaPlayerState.esAdded:
            print("Elementary Stream added")
        default:
            print("default")
        }
    }
    
    func prepareVideoInfo (avId: String, cid: String) -> Void {
        do {
            try self.loadMediaData(avId: avId, cid: cid)
        } catch let error {
            print("Can not play. Error: \(error)")
            if let nav = self.navigationController {
                nav.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func loadData(avId: String, seasonId:String, pageNum:Int) -> Void {
        AF.request(Urls.getBangumiInfo(seasonId: seasonId)).responseJSON { response in
            switch(response.result) {
            case .success(let data):
                self.videoInfo = JSON(data)["result"]["main_section"]
                let cid = self.videoInfo["episodes"][pageNum]["cid"].stringValue
                self.prepareVideoInfo(avId: avId, cid: cid)
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func loadData(avId:String, pageNum:Int) -> Void {
        if self.videoInfo.isEmpty {
            AF.request(Urls.getVideoInfo(avId: avId)).responseJSON { response in
                switch(response.result) {
                case .success(let data):
                    self.videoInfo = JSON(data)["data"]
                    var cid = self.videoInfo["cid"].stringValue
                    if pageNum != 0 {
                        cid = self.videoInfo["pages"][pageNum]["cid"].stringValue
                    }
                    self.prepareVideoInfo(avId: avId, cid: cid)
                    
                case .failure(let error):
                    print(error)
                    break
                }
            }
        } else {
            var cid = self.videoInfo["cid"].stringValue
            if pageNum != 0 {
                cid = self.videoInfo["pages"][pageNum]["cid"].stringValue
            }
            self.prepareVideoInfo(avId: avId, cid: cid)
        }
        
    }
}
