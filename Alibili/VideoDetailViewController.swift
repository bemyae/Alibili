//
//  VideoDetailController.swift
//  Alibili
//
//  Created by xnzhang on 2020/09/10.
//  Copyright © 2020 Xiaonan Zhang. All rights reserved.
//

import UIKit

class VideoDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let cookieManager:CookieManager = CookieManager()
    var videoJson:CellDataItem!

    @IBOutlet weak var VideoTitle: UITextView!
    @IBOutlet weak var VideoDescription: UITextView!
    @IBOutlet weak var PartTableView: UITableView!
    
    var parts:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PartTableView.delegate = self
        PartTableView.dataSource = self
        
        // Do any additional setup after loading the view.
        VideoTitle.text = videoJson.title
        parts = Array(1...videoJson.videos)
        
        VideoDescription.text = videoJson.desc
//        print(VideoDescription.text.count)
//        let range = NSMakeRange(VideoDescription.text.count - 1, 1)
//        VideoDescription.scrollRangeToVisible(range)
        
//        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = view.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        self.view.addSubview(blurEffectView)
        
        guard let image = self.processImage(named: videoJson.pic) else { return }
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
            destination.pageNum = index.row
            destination.videoJson = self.videoJson
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
    
}
