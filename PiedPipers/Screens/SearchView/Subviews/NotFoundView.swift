//
//  NotFoundView.swift
//  PiedPipers
//
//  Created by david rogel pernas on 29/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit

class NotFoundView: UIView
{
    let label:UILabel = {
        let lbl = UILabel()
        lbl.text = "Nothing was found"
        lbl.textAlignment = .center
        return lbl
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addSubview(label)
    }
    
    override func layoutSubviews()
    {
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
}
