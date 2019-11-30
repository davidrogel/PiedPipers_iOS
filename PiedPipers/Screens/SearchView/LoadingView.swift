//
//  LoadingView.swift
//  PiedPipers
//
//  Created by david rogel pernas on 29/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit

class LoadingView: UIView
{
    private let loading:UIActivityIndicatorView =
    {
        let ai = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
//        ai.isHidden = true
        return ai
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addSubview(loading)
    }
    
    override func layoutSubviews()
    {
        loading.translatesAutoresizingMaskIntoConstraints = false
        
        loading.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        loading.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
    
    public func showAndStartAnimate()
    {
        loading.startAnimating()
        self.isHidden = false
    }
    
    public func hideAndStopAnimate()
    {
        loading.stopAnimating()
        self.isHidden = true
    }
}
