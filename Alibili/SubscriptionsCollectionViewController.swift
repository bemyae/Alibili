//
//  RecentsCollectionViewController.swift
//  Alibili
//
//  Created by Xiaonan Zhang on 2019/07/08.
//  Copyright © 2019 Xiaonan Zhang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

private let reuseIdentifier = SubscriptionsCollectionViewCell.reuseIdentifier

class SubscriptionsCollectionViewController: UICollectionViewController {

    private let cookieManager:CookieManager = CookieManager()
    
    private let cellComposer = DataItemCellComposer()
    
    private var targetSize = CGSize.zero
    
    var dataItemGourp:[JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let kCellReuseIdentifier = "Cell"
        let kColumnCnt: Int = 3
        let kCellSpacing: CGFloat = 40
//        var fetchResult: PHFetchResult<PHAsset>!
//        var imageManager = PHCachingImageManager()
        

        let imgWidth = (collectionView.frame.width - (kCellSpacing * (CGFloat(kColumnCnt) - 1))) / CGFloat(kColumnCnt)
        targetSize = CGSize(width: imgWidth, height: imgWidth * 9 / 16)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = targetSize
        layout.minimumInteritemSpacing = kCellSpacing
        layout.minimumLineSpacing = kCellSpacing
        collectionView.collectionViewLayout = layout
//        self.edgesForExtendedLayout = UIRectEdge.bottom
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(SubscriptionsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        if(cookieManager.isUserCookieSet(forKey: "User-Cookie")){
            let headers: HTTPHeaders = [
                "Set-Cookie":cookieManager.getUserCookie(forKey: "User-Cookie")!,
                "Accept": "application/json"
            ]
            AF.request("https://api.bilibili.com/x/web-feed/feed?ps=10&pn=1", headers: headers).responseJSON { response in
                switch(response.result) {
                case .success(let data):
                    let json = JSON(data)
//                    print(json)
                    self.dataItemGourp = json["data"].array ?? []
                    DispatchQueue.main.async{
                        self.collectionView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                    break
                }
                
            }
            
        }
        // Do any additional setup after loading the view.
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.dataItemGourp.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubscriptionsCollectionViewCell.reuseIdentifier, for: indexPath)
        return cell
        

    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? SubscriptionsCollectionViewCell else { fatalError("Expected to display a `SubscriptionsCollectionViewCell`.") }
//        cell.backgroundColor = randomColor()
        let item = dataItemGourp[indexPath.item]
        //         Configure the cell.
        cellComposer.compose(cell, cellStyle: targetSize ,withDataItem: DataItem(jsonData: item))
    }
    
    func randomColor() -> UIColor{
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    // MARK: UICollectionViewDelegate
    
//    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        guard cell is RecentsCollectionViewCell else { fatalError("Expected to display a RecentsCollectionCell") }
//        print((indexPath as NSIndexPath).row)
//        let item = dataItemGourp[indexPath]
//        print(item)
        // Configure the cell.
//        DataItemCellComposer.compose(cell, withDataItem: item)
//    }

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
