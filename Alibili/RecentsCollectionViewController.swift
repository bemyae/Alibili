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

private let reuseIdentifier = RecentsCollectionViewCell.reuseIdentifier

class RecentsCollectionViewController: UICollectionViewController {

    let cookieManager:CookieManager = CookieManager()
    
    var dataItemGourp:[JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        if(cookieManager.isUserCookieSet(forKey: "User-Cookie")){
            let headers: HTTPHeaders = [
                "Set-Cookie":cookieManager.getUserCookie(forKey: "User-Cookie")!,
                "Accept": "application/json"
            ]
            AF.request("https://api.bilibili.com/x/web-feed/feed?ps=10&pn=1", headers: headers).responseJSON { response in
                switch(response.result) {
                    case .success(let data):
                         let json = JSON(data)
                         self.dataItemGourp = json["data"].array ?? []
                    case .failure(let error):
                        break
                }
                
            }
            
        }
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
        return dataItemGourp.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
        
        // Configure the cell.
        let sectionDataItems = dataItemGourp[indexPath.section]
//        print(sectionDataItems)
        cell.backgroundColor = randomColor()
        return cell
    }
    
    // custom function to generate a random UIColor
    func randomColor() -> UIColor{
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }

    // MARK: UICollectionViewDelegate

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

//struct Owner : Codable{
//    var mid:String
//    var name:String
//    var face:String
//}
//
//struct Archive : Codable{
//    var aid :String
//    var videos:Int
//    var tid :String
//    var tname:String
//    var copyright :Int
//    var pic: String
//    var title :String
//    var pubdate:String
//    var ctime:String
//    var desc:String
//    var state:Int
//    var attribute:String
//    var duration:String
//    var owner:Owner
//    var dynamic:String
//    var cid:String
//}
//
//struct OfficialVerify: Codable {
//    var role :Int
//    var title :String
//    var desc :String
//}
//
//struct Video : Codable{
//    var type:Int
//    var archive: Archive
//    var bangumi: String
//    var id: String
//    var pubdate :String
//    var fold:String
//    var official_verify : OfficialVerify
//}
//
//struct Recents : Codable{
//    var code:Int
//    var message: Int
//    var ttl:Int
//    var data:[Video]
//}
