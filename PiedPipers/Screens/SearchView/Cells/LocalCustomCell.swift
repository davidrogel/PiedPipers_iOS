//
//  LocalCustomCell.swift
//  PiedPipers
//
//  Created by david rogel pernas on 04/12/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit

/// Celda dedicada a mostrar Locales
class LocalCustomCell: BasePiperCustomCell
{
    // MARK: - Constructors
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
    
    // MARK: - Setters
    
    public func setPortrait(withImage image: UIImage)
    {
        portrait.image = image
    }
    
    public func setName(name:String)
    {
        nameLabel.text = name
    }
    
    public func setPrice(price: String)
    {
        secondLabel.text = price
    }
    
    public func setDescription(text: String)
    {
        let descriptionLabel: UILabel = {
            let label = UILabel()
            label.text = text
            label.textColor = .lightGray
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        self.dataView.addSubview(descriptionLabel)
        
        descriptionLabel.leadingAnchor.constraint(equalTo: self.dataView.leadingAnchor, constant: 16).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: self.dataView.trailingAnchor, constant: -16).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: self.dataView.bottomAnchor, constant: -8).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16).isActive = true
    }
}
