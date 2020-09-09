//
//  RecentsCollectionViewCell.swift
//  Alibili
//
//  Created by Xiaonan Zhang on 2019/07/08.
//  Copyright © 2019 Xiaonan Zhang. All rights reserved.
//

import UIKit
import SwiftyJSON

class SubscriptionsCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "SubscriptionsCollectionViewCell"
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    var representedDataItem: SubscriptionsCellDataItem?
    
    // MARK: Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // These properties are also exposed in Interface Builder.
        imageView.adjustsImageWhenAncestorFocused = true
        imageView.clipsToBounds = false
        // label.alpha = 0.0
    }
    
    // MARK: UICollectionReusableView
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Reset the label's alpha value so it's initially hidden.
        // label.alpha = 0.0
    }
    
    // MARK: UIFocusEnvironment
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        /*
         Update the label's alpha value using the `UIFocusAnimationCoordinator`.
         This will ensure all animations run alongside each other when the focus
         changes.
         */
//        coordinator.addCoordinatedAnimations({
//            if self.isFocused {
//                self.label.alpha = 1.0
//            }
//            else {
//                self.label.alpha = 0.0
//            }
//        }, completion: nil)
    }
}
