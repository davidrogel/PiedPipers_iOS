//
//  ProfileCustomCell.swift
//  PiedPipers
//
//  Created by david rogel pernas on 01/12/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit

/// Celda dedicada  a mostrar Perfiles de usuarios
class ProfileCustomCell: BasePiperCustomCell
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
    
    public func setFriendlyLocation(name: String)
    {
        secondLabel.text = name
    }
    
    public func setInstruments(instruments: [String])
    {
        if instruments.isEmpty { return }
        
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

