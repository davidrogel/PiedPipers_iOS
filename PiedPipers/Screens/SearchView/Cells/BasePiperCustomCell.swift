//
//  BasePiperCustomCell.swift
//  PiedPipers
//
//  Created by david rogel pernas on 04/12/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit

class BasePiperCustomCell: UICollectionViewCell
{
    let portrait:UIImageView = {
        let iv = UIImageView(image: UIImage(named: "placeholder"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 24
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let dataView:UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 24
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let nameLabel:UILabel = {
        let lbl = UILabel()
        lbl.text = "Name"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let secondLabel:UILabel = {
        let lbl = UILabel()
        lbl.text = "00.00"
        lbl.textColor = .lightGray
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        addSubview(portrait)
        addSubview(dataView)
        
        configurePortraitConstraints()
        configureDataViewConstraints()
        
        self.dataView.addSubview(nameLabel)
        self.dataView.addSubview(secondLabel)
        
        configureNameLabelConstraints()
        configureBandNameLabelConstraints()
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        dataViewShadow()
    }
}

extension BasePiperCustomCell
{
    private func dataViewShadow()
    {
        let shadowPath = UIBezierPath(roundedRect: dataView.bounds, cornerRadius: 30)
        
        dataView.layer.shadowPath = shadowPath.cgPath
        dataView.layer.shadowColor = UIColor(red: 0.227, green: 0.227, blue: 0.227, alpha: 0.3).cgColor
        dataView.layer.shadowOpacity = 1
        dataView.layer.shadowRadius = 8
        dataView.layer.shadowOffset = CGSize(width: 0, height: 0.333)
        dataView.layer.bounds = dataView.bounds
        dataView.layer.position = dataView.center
    }
    
    private func configurePortraitConstraints()
    {
        portrait.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        portrait.bottomAnchor.constraint(equalTo: dataView.centerYAnchor).isActive = true
        portrait.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        portrait.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
    }
    
    private func configureDataViewConstraints()
    {
        dataView.heightAnchor.constraint(equalToConstant: 85).isActive = true
        dataView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dataView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        dataView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
    }
    
    private func configureNameLabelConstraints()
    {
        nameLabel.topAnchor.constraint(equalTo: dataView.topAnchor, constant: 16).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: secondLabel.bottomAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: dataView.leadingAnchor, constant: 16).isActive = true
    }
    
    private func configureBandNameLabelConstraints()
    {
        secondLabel.topAnchor.constraint(equalTo: dataView.topAnchor, constant: 16).isActive = true
        secondLabel.trailingAnchor.constraint(equalTo: dataView.trailingAnchor, constant: -16).isActive = true
        secondLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8).isActive = true
        secondLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
}

