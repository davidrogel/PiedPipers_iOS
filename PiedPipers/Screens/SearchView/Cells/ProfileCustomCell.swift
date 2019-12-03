//
//  ProfileCustomCell.swift
//  PiedPipers
//
//  Created by david rogel pernas on 01/12/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit

class ProfileCustomCell: UICollectionViewCell
{
    private let portrait:UIImageView = {
        let iv = UIImageView(image: UIImage(named: "kojima"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 24
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let dataView:UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 24
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let nameLabel:UILabel = {
        let lbl = UILabel()
        lbl.text = "Hideo Kojima"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let bandNameLabel:UILabel = {
        let lbl = UILabel()
        lbl.text = "Band"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .lightGray
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
        self.dataView.addSubview(bandNameLabel)
        
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
    
    public func setPortrait(withImage image: UIImage)
    {
        portrait.image = image
    }
    
    public func setName(name:String?)
    {
        nameLabel.text = name
    }
    
    public func setBand(name: String?)
    {
        bandNameLabel.text = name
    }
    
    public func setInstruments(instruments: [String]?)
    {
        guard let instruments = instruments else { return }
        
        if instruments.count > 2
        {
            for i in 0..<2
            {
                let name = instruments[i]
                let instrumentLabel: UILabel = {
                    let label = UILabel()
                    label.text = name
                    label.textAlignment = .center
                    label.layer.backgroundColor = UIColor(red: 0.514, green: 0.557, blue: 0.871, alpha: 1).cgColor
                    label.layer.cornerRadius = 10
                    label.translatesAutoresizingMaskIntoConstraints = false
                    return label
                }()
                
                self.dataView.addSubview(instrumentLabel)
                
                if i == 0
                {
                    instrumentLabel.leadingAnchor.constraint(equalTo: self.dataView.leadingAnchor, constant: 16).isActive = true
                    instrumentLabel.bottomAnchor.constraint(equalTo: self.dataView.bottomAnchor, constant: -8).isActive = true
                    instrumentLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
                    continue
                }
                
                let lastViewAdded = self.dataView.subviews[self.dataView.subviews.count - 2]
                
                instrumentLabel.leadingAnchor.constraint(equalTo: lastViewAdded.trailingAnchor, constant: 8).isActive = true
                instrumentLabel.bottomAnchor.constraint(equalTo: lastViewAdded.bottomAnchor).isActive = true
                instrumentLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
            }
            
            let remaining = instruments.count - 2
            
            if remaining <= 0
            {
                return
            }
            
            let endView = self.dataView.subviews[self.dataView.subviews.count - 1]
            
            let instrumentsRemaining: UILabel = {
               
                let label = UILabel()
                label.text = "+\(remaining)"
                label.textAlignment = .center
                label.textColor = UIColor(red: 0.514, green: 0.557, blue: 0.871, alpha: 1)
                label.backgroundColor = .white
                label.layer.borderColor = UIColor(red: 0.514, green: 0.557, blue: 0.871, alpha: 1).cgColor
                label.layer.cornerRadius = 10
                label.layer.borderWidth = 1
                label.translatesAutoresizingMaskIntoConstraints = false
                return label
            }()
            
            self.dataView.addSubview(instrumentsRemaining)
            
            instrumentsRemaining.leadingAnchor.constraint(equalTo: endView.trailingAnchor, constant: 8).isActive = true
            instrumentsRemaining.bottomAnchor.constraint(equalTo: endView.bottomAnchor).isActive = true
            instrumentsRemaining.widthAnchor.constraint(equalToConstant: 50).isActive = true
        }
        else
        {
            for i in 0..<instruments.count
            {
                let name = instruments[i]
                let instrumentLabel: UILabel = {
                    let label = UILabel()
                    label.text = name
                    label.textAlignment = .center
                    label.layer.backgroundColor = UIColor(red: 0.514, green: 0.557, blue: 0.871, alpha: 1).cgColor
                    label.layer.cornerRadius = 10
                    label.translatesAutoresizingMaskIntoConstraints = false
                    return label
                }()
                
                self.dataView.addSubview(instrumentLabel)
                
                if i == 0
                {
                    instrumentLabel.leadingAnchor.constraint(equalTo: self.dataView.leadingAnchor, constant: 16).isActive = true
                    instrumentLabel.bottomAnchor.constraint(equalTo: self.dataView.bottomAnchor, constant: -8).isActive = true
                    instrumentLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
                    continue
                }
                
                let lastViewAdded = self.dataView.subviews[self.dataView.subviews.count - 2]
                
                instrumentLabel.leadingAnchor.constraint(equalTo: lastViewAdded.trailingAnchor, constant: 8).isActive = true
                instrumentLabel.bottomAnchor.constraint(equalTo: lastViewAdded.bottomAnchor).isActive = true
                instrumentLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
            }
        }
        
    }
}

extension ProfileCustomCell
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
        nameLabel.bottomAnchor.constraint(equalTo: bandNameLabel.bottomAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: dataView.leadingAnchor, constant: 16).isActive = true
    }
    
    private func configureBandNameLabelConstraints()
    {
        bandNameLabel.topAnchor.constraint(equalTo: dataView.topAnchor, constant: 16).isActive = true
        bandNameLabel.trailingAnchor.constraint(equalTo: dataView.trailingAnchor, constant: -16).isActive = true
        bandNameLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8).isActive = true
        bandNameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
}
