//
//  RecentsCollectionViewCell.swift
//  Alibili
//
//  Created by Xiaonan Zhang on 2019/07/08.
//  Copyright © 2019 Xiaonan Zhang. All rights reserved.
//

import UIKit
import SwiftyJSON

class RecentsCollectionViewCell: UICollectionViewCell{
    
    private var dataItems:[JSON] = []
    
    func configure(with dataItems: [JSON]) {
        self.dataItems = dataItems

    }
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
    
    
    static let reuseIdentifier = "RecentsCollectionViewCell"
    
}
