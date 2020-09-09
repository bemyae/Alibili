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
import AVKit

private let reuseIdentifier = SubscriptionsCollectionViewCell.reuseIdentifier

class SubscriptionsCollectionViewController: UICollectionViewController {

    private let cookieManager:CookieManager = CookieManager()
    
    private let cellComposer = SubscriptionsCellDataComposer()
    
    private var targetSize = CGSize.zero
    
    private let recentTotal = 100
    private let recentPerPage = 10
    private var recentCurrentPage = 1
    
    var dataItemGourp:[JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let kColumnCnt: Int = 3
        let kCellSpacing: CGFloat = 40

        let imgWidth = (collectionView.frame.width - (kCellSpacing * (CGFloat(kColumnCnt) - 1))) / CGFloat(kColumnCnt)
        targetSize = CGSize(width: imgWidth, height: imgWidth * 9 / 16)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = targetSize
        layout.minimumInteritemSpacing = kCellSpacing
        layout.minimumLineSpacing = kCellSpacing
        collectionView.collectionViewLayout = layout

        if(cookieManager.isUserCookieSet(forKey: "User-Cookie")){
            loadMoreData(currentPage:1)
        }
    }

    func loadMoreData(currentPage:Int) -> Void {
        if (currentPage < recentCurrentPage || recentCurrentPage * recentPerPage > recentTotal) {return}
        let headers: HTTPHeaders = [
            "Set-Cookie":cookieManager.getUserCookie(forKey: "User-Cookie")!,
            "Accept": "application/json"
        ]
        AF.request(Urls.getSubscription(recentPerPage: recentPerPage, currentPage: currentPage), headers: headers).responseJSON { response in
            switch(response.result) {
            case .success(let data):
                let json = JSON(data)
                self.dataItemGourp.append(contentsOf: json["data"].array ?? [])
                self.recentCurrentPage+=1
                DispatchQueue.main.async{
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
                break
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
        cellComposer.compose(cell, cellStyle: targetSize ,withDataItem: SubscriptionsCellDataItem(jsonData: item))
        
        if dataItemGourp.count - 1 == indexPath.item {
            loadMoreData(currentPage: recentCurrentPage)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as?
            VideoPlayerViewController, let index =
            collectionView.indexPathsForSelectedItems?.first {
            let item = dataItemGourp[index.item]
            destination.videoJson = SubscriptionsCellDataItem(jsonData: item)
        }
    }
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        let item = dataItemGourp[indexPath.item]
//        let data = DataItem(jsonData: item)
//        loadItemData(avId: data.id, pageNum: 1)
//
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

//        print(Urls.getVideo(avId: String, pageNum: String))
//        AF.request(Urls.getVideo(avId: String, pageNum: String), headers: headers).responseString { response in
//
//            if let playInfoRange = response.description.range(of: #"__playinfo__=(.*?)<\/script>"#,
//                                            options: .regularExpression) {
//               let playInfoString = response.description[playInfoRange].replacingOccurrences(
//                    of: "__playinfo__=(.*?)</script>$",
//                    with: "$1",
//                    options: .regularExpression,
//                    range: playInfoRange
//                ).replacingOccurrences(of: "\\\"", with: "\"")
//                if let dataFromString = playInfoString.data(using: .utf8, allowLossyConversion: false) {
//                    do {
//                        let json = try JSON(data: dataFromString)
//                        print(json)
//                    } catch {
//                        print(error)
//                    }
//                }
//
//
//            } else {
//                print("1 -----")
//            }
//            print("----------------------------")
//            if let initialStateRange = response.description.range(of: #"__INITIAL_STATE__=(.*?)\};"#,
//                                                      options: .regularExpression) {
//                var initialStateString = response.description[initialStateRange].replacingOccurrences(
//                    of: #"__INITIAL_STATE__=(.*?)\};$"#,
//                    with: #"$1"#,
//                    options: .regularExpression,
//                    range: initialStateRange
//                    ).replacingOccurrences(of: "\\u002F", with: "/")
//                    .replacingOccurrences(of: #"\/"#, with: "/")
//                    .replacingOccurrences(of: "\\\"", with: "\"")
//                    .replacingOccurrences(of: #",\"embedPlayer\":\"EmbedPlayer(.*?)\)\""#, with: "", options: [.regularExpression])
//
//                initialStateString.append("}")
//
//
//                if let dataFromString = initialStateString.data(using: .utf8, allowLossyConversion: false) {
//                    do {
//                        let json = try JSON(data: dataFromString)
//                        print(json)
//                    } catch {
//                        print(error)
//                    }
//                }
//
//            } else {
//                print("2 -----")
//            }
//            print(response)
//            switch(response.result) {
//            case .success(let data):
////                let json = JSON(data)
//                print(data)
//            case .failure(let error):
//                print(error)
//                break
//            }
//
//        }
