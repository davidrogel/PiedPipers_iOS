//
//  VideoCollectionViewCell.swift
//  PiedPipers
//
//  Created by Jon Gonzalez on 13/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit
import Kingfisher

class VideoCollectionViewCell: UICollectionViewCell {
    
    static let nibName = String(describing: VideoCollectionViewCell.self)
    static let reusableId = String(describing: VideoCollectionViewCell.self)

    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var removeButton: UIImageView!
    
    var image: String! {
        didSet {
            if image == "Add" {
                videoImage.image = UIImage(named: "videoPlaceholder")
            } else {
                let url = URL(string: image)
                videoImage.kf.setImage(with: url)
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        videoImage.layer.cornerRadius = 20
        videoImage.layer.masksToBounds = true
        videoImage.layer.borderColor = UIColor.systemGray4.cgColor
        videoImage.layer.borderWidth = 1
        
        removeButton.isHidden = true
    }
    
    func showRemoveButton() {
        removeButton.isHidden = false
        self.sendSubviewToBack(videoImage)
    }
    
    func hideRemoveButton() {
        removeButton.isHidden = true
        removeButton.image = UIImage(systemName: "multiply.circle.fill")
    }
    
    func selectedToRemove() {
        videoImage.alpha = 0.5
        removeButton.image = UIImage(systemName: "checkmark.circle.fill")
    }
    
    func showAddCell() {
        videoImage.image = UIImage(named: "videoPlaceholder")
        videoImage.layer.borderWidth = 0
    }
    
    func deselectCell() {
        videoImage.alpha = 1
        removeButton.image = UIImage(systemName: "multiply.circle.fill")
    }

}
