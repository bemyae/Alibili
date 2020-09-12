//
//  TabBarViewController.swift
//  Alibili
//
//  Created by xnzhang on 2020/09/11.
//  Copyright © 2020 Xiaonan Zhang. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }
    
   func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let destination = viewController as?
            SubscriptionsCollectionViewController {
            if destination.recentCurrentPage != 1{
                destination.dataItemGourp=[]
                destination.recentCurrentPage = 1
                destination.loadMoreData(currentPage: 1)
            }
        }
        
        if let destination = viewController as?
            HistoryCollectionViewController {
            if destination.recentCurrentPage != 1{
                destination.dataItemGourp=[]
                destination.recentCurrentPage = 1
                destination.loadMoreData(currentPage: 1)
            }
        }
    }
    
    
    
    

}
