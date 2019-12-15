//
//  ImagesCollectionViewCell.swift
//  PiedPipers
//
//  Created by Jon Gonzalez on 15/12/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit
import Kingfisher

class ImagesCollectionViewCell: UICollectionViewCell {
    
    static let nibName = String(describing: ImagesCollectionViewCell.self)
    static let reusableId = String(describing: ImagesCollectionViewCell.self)
    
    // MARK: Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Properties
    var image: String! {
        didSet {
//            let url = String.createUrl(fromImgPath: image)
//            imageView.kf.setImage(with: url)
            
            imageView.image = UIImage(named: image)
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
    }

}
