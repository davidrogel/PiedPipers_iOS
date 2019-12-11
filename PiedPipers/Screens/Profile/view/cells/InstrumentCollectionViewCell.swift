//
//  InstrumentCollectionViewCell.swift
//  PiedPipers
//
//  Created by Jon Gonzalez on 13/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit

class InstrumentCollectionViewCell: UICollectionViewCell {
    
    static let nibName = String(describing: InstrumentCollectionViewCell.self)
    static let reusableId = String(describing: InstrumentCollectionViewCell.self)
    
    
    @IBOutlet weak var instrumentLabel: UILabel!
    @IBOutlet weak var removeButton: UIImageView!
    
    var name: String! {
        didSet {
            instrumentLabel.text = name
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        instrumentLabel.layer.cornerRadius = 14
        instrumentLabel.layer.masksToBounds = true
        let device = UIDevice()
        if (device.name == "iPhone SE") {
            instrumentLabel.font = .systemFont(ofSize: 14)
        }
        
        removeButton.isHidden = true
    }
    
    func showRemoveButton() {
        removeButton.isHidden = false
        self.sendSubviewToBack(instrumentLabel)
    }
    
    func hideRemoveButton() {
        instrumentLabel.backgroundColor = UIColor.systemIndigo
        removeButton.isHidden = true
        removeButton.image = UIImage(systemName: "multiply.circle.fill")
    }
    
    func selectedToRemove() {
        instrumentLabel.layer.borderWidth = 0
        instrumentLabel.backgroundColor = UIColor.systemGray4
        instrumentLabel.textColor = UIColor.systemBackground
        removeButton.image = UIImage(systemName: "checkmark.circle.fill")
    }
    
    func showAddCell() {
        removeButton.isHidden = true
        instrumentLabel.layer.borderColor = UIColor.systemGray2.cgColor
        instrumentLabel.layer.borderWidth = 1.0
        instrumentLabel.backgroundColor = UIColor(ciColor: .white)
        instrumentLabel.textColor = UIColor.systemGray2
    }
    
    func deselectCell() {
        instrumentLabel.layer.borderWidth = 0
        instrumentLabel.backgroundColor = UIColor.systemIndigo
        instrumentLabel.textColor = UIColor.systemBackground
        removeButton.image = UIImage(systemName: "multiply.circle.fill")
    }

}
