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
    // MARK: - Views
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Constructors
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.dataView.addSubview(descriptionLabel)
        secondLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        configureDescriptionLabelConstraints()
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
    
    // MARK: - Filler
    
    public func fill(withLocalPresentable local: SearchLocalPresentable)
    {
        nameLabel.text = local.localName
        secondLabel.text = local.price
        descriptionLabel.text = local.description
        Loader.loadImg(onImageView: portrait, from: String.createUrl(fromImgPath: local.image), placeholder: placeholder!)
    }
}

extension LocalCustomCell
{
    private func configureDescriptionLabelConstraints()
    {
        descriptionLabel.leadingAnchor.constraint(equalTo: self.dataView.leadingAnchor, constant: 16).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: self.dataView.trailingAnchor, constant: -16).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: self.dataView.bottomAnchor, constant: -8).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16).isActive = true
    }
}
