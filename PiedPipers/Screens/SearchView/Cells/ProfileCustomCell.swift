//
//  ProfileCustomCell.swift
//  PiedPipers
//
//  Created by david rogel pernas on 01/12/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit

final class SearchInstrumentLabel: UILabel
{
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        isHidden = true
        textAlignment = .center
        textColor = .white
        layer.backgroundColor = UIColor(red: 0.514, green: 0.557, blue: 0.871, alpha: 1).cgColor
        layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
}

final class RemainingInstrumentsLabel: UILabel
{
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        isHidden = true
//        text = "+\(remaining)"
        textAlignment = .center
        textColor = UIColor(red: 0.514, green: 0.557, blue: 0.871, alpha: 1)
        backgroundColor = .white
        layer.borderColor = UIColor(red: 0.514, green: 0.557, blue: 0.871, alpha: 1).cgColor
        layer.cornerRadius = 10
        layer.borderWidth = 1
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
}

/// Celda dedicada  a mostrar Perfiles de usuarios
class ProfileCustomCell: BasePiperCustomCell
{
    // MARK: - Views
    
    private let instrumentLbls: [SearchInstrumentLabel] = [SearchInstrumentLabel(), SearchInstrumentLabel()]
    private let remainingInstrumentsLbl: RemainingInstrumentsLabel = RemainingInstrumentsLabel()
    
    // MARK: - Constructors
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        secondLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        configureInstrumentsLabelsConstraints()
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
    
    // MARK: - Filler
    
    public func fill(withProfilePresentable profile: SearchProfilePresentable)
    {
        nameLabel.text = profile.profileName
        secondLabel.text = profile.friendlyLocation
        Loader.loadImg(onImageView: portrait, from: String.createUrl(fromImgPath: profile.image), placeholder: placeholder!)
        setInstruments(instruments: profile.instruments)
    }
    
    private func setInstruments(instruments: [String])
    {
        if instruments.isEmpty { return }
        
        if instruments.count > 2
        {
            for i in 0..<2
            {
                let name = instruments[i]
                setAndShowInstrumentLabel(index: i, name: name)
            }
            
            let remaining = instruments.count - 2

            if remaining <= 0
            {
                return
            }
            
            setAndShowRemainingInstruments(count: remaining)
        }
        else
        {
            for i in 0..<instruments.count
            {
                let name = instruments[i]
                setAndShowInstrumentLabel(index: i, name: name)
            }
        }
    }
    
    private func setAndShowInstrumentLabel(index: Int, name: String)
    {
        instrumentLbls[index].text = name
        instrumentLbls[index].isHidden = false
    }
    
    private func setAndShowRemainingInstruments(count: Int)
    {
        remainingInstrumentsLbl.text = "+\(count)"
        remainingInstrumentsLbl.isHidden = false
    }
    
    // MARK: - Prepare it
    override func prepareForReuse()
    {
        super.prepareForReuse()
        
        nameLabel.text = ""
        secondLabel.text = ""
        portrait.image = nil
        for v in instrumentLbls
        {
            v.text = ""
            v.isHidden = true
        }
        remainingInstrumentsLbl.text = ""
        remainingInstrumentsLbl.isHidden = true
    }
}

// MARK: - Constraints
extension ProfileCustomCell
{
    private func configureInstrumentsLabelsConstraints()
    {
        let first = instrumentLbls[0]
        let second = instrumentLbls[1]
        
        dataView.addSubview(first)
        dataView.addSubview(second)
        dataView.addSubview(remainingInstrumentsLbl)
        
        first.leadingAnchor.constraint(equalTo: self.dataView.leadingAnchor, constant: 16).isActive = true
        first.bottomAnchor.constraint(equalTo: self.dataView.bottomAnchor, constant: -8).isActive = true
        first.widthAnchor.constraint(equalToConstant: 100).isActive = true

        second.leadingAnchor.constraint(equalTo: first.trailingAnchor, constant: 8).isActive = true
        second.bottomAnchor.constraint(equalTo: first.bottomAnchor).isActive = true
        second.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        remainingInstrumentsLbl.leadingAnchor.constraint(equalTo: second.trailingAnchor, constant: 8).isActive = true
        remainingInstrumentsLbl.bottomAnchor.constraint(equalTo: second.bottomAnchor).isActive = true
        remainingInstrumentsLbl.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
