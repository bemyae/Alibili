//
//  VideoDetailController.swift
//  Alibili
//
//  Created by xnzhang on 2020/09/10.
//  Copyright © 2020 Xiaonan Zhang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class VideoDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let cookieManager:CookieManager = CookieManager()
    var videoJson:CellDataItem!
    var videoInfo:JSON = JSON({})
    var parts:[Int] = []

    @IBOutlet weak var Owner: UIButton!
    @IBOutlet weak var VideoTitle: UITextView!
    @IBOutlet weak var VideoDescription: UITextView!
    @IBOutlet weak var PartTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PartTableView.delegate = self
        PartTableView.dataSource = self
        
        // Do any additional setup after loading the view.
        VideoTitle.text = videoJson.title
        
        if videoJson.videoDetail.videos == -1 {
            loadData(aid: videoJson.aid)
        } else {
            parts = Array(1...videoJson.videoDetail.videos)
            VideoDescription.text = videoJson.videoDetail.desc
            Owner.setTitle(videoJson.videoDetail.owner.name, for: .normal)
        }
        var pic = videoJson.pic
        if !pic.contains("http:") {
            pic = "http:" + pic
        }
        
        guard let image = self.processImage(named: pic) else { return }
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = image
        backgroundImage.alpha = 0.5
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    private func processImage(named imageName: String) -> UIImage? {
        let url = URL(string: imageName)
        let data = try? Data(contentsOf: url!)
        if (data == nil) {
            return nil
        }
        // Load the image.
        guard let image = UIImage(data: data!) else { return nil }
        
        /*
         We only need to process jpeg images. Do no processing if the image
         name doesn't have a jpg suffix.
         */
        guard imageName.hasSuffix(".jpg") else { return image }
        
        // Create a `CGColorSpace` and `CGBitmapInfo` value that is appropriate for the device.
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
        
        // Create a bitmap context of the same size as the image.
        let imageWidth = Int(Float(image.size.width))
        let imageHeight = Int(Float(image.size.height))
        
        let bitmapContext = CGContext(data: nil, width: imageWidth, height: imageHeight, bitsPerComponent: 8, bytesPerRow: imageWidth * 4, space: colorSpace, bitmapInfo: bitmapInfo)
        
        // Draw the image into the graphics context.
        guard let imageRef = image.cgImage else { fatalError("Unable to get a CGImage from a UIImage.") }
        bitmapContext?.draw(imageRef, in: CGRect(origin: CGPoint.zero, size: image.size))
        
        
        // Create a new `CGImage` from the contents of the graphics context.
        guard let newImageRef = bitmapContext?.makeImage() else { return image }
        
        // Return a new `UIImage` created from the `CGImage`.
        return UIImage(cgImage: newImageRef)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as?
            VideoPlayerViewController, let index =
            PartTableView.indexPathsForSelectedRows?.first {
            destination.videoInfo = self.videoInfo
            destination.pageNum = index.row
            destination.videoJson = self.videoJson
        }
        
        if let destination = segue.destination as?
            VideoRelationCollectionViewController {
            destination.aid = self.videoJson.aid
        }
        
        if let destination = segue.destination as?
            OwnerCollectionViewController {
            destination.owner = self.videoJson.videoDetail.owner
        }
    }
    
    func loadData(aid:String) -> Void {
        if(cookieManager.isUserCookieSet(forKey: "User-Cookie")){
            let headers: HTTPHeaders = [
                "Set-Cookie":cookieManager.getUserCookie(forKey: "User-Cookie")!,
                "Accept": "application/json"
            ]
            AF.request(Urls.getVideoInfo(avId: aid),headers:headers).responseJSON { response in
                switch(response.result) {
                    case .success(let data):
                        self.videoInfo = JSON(data)["data"]
                        self.videoJson.videoDetail = VideoDetail(jsonData: self.videoInfo)
                        self.parts = Array(1...self.videoJson.videoDetail.videos)
                        self.VideoDescription.text = self.videoJson.videoDetail.desc
                        self.Owner.setTitle(self.videoJson.videoDetail.owner.name, for: .normal)
                        self.PartTableView.reloadData()
                    case .failure(let error):
                        print(error)
                        break
                    }
            }
        }
    }
    
    /*
    // MARK: - tableview delegate & datasource -
    */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PartTableCell", for: indexPath)
        cell.textLabel!.text = String(parts[indexPath.row])
        return cell
    }
    
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [PartTableView]
    }
    
}
