//
//  FilterButton.swift
//  PiedPipers
//
//  Created by david rogel pernas on 25/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit

class FilterButton : UIButton
{
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
//        let btn = UIButton(type: UIButton.ButtonType.roundedRect)
//        btn.buttonType = UIButton.ButtonType.roundedRect
//        btn.setTitle("Filters", for: .normal)
//        self.addTarget(self, action: #selector(filtersButtonPressed), for: .touchUpInside)
//        btn.layer.cornerRadius = btn.frame.height * 0.5
//        btn.setImage(#imageLiteral(resourceName: "Search.png"), for: UIControl.State.normal)
        
        self.backgroundColor = .white
        
        addShadows()
        addShape()
        addImage()

//        btn.sendSubviewToBack(imageView)
//        btn.sendSubviewToBack(shapes)
//        btn.sendSubviewToBack(shadows)
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
    
    private func addShadows()
    {
        let shadows = UIView()
        shadows.frame = self.frame
        shadows.clipsToBounds = false
        shadows.isUserInteractionEnabled = false
        
        self.addSubview(shadows)
        
        let shadowPath0 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: self.frame.height * 0.5)
        
        let layer0 = CALayer()
        layer0.shadowPath = shadowPath0.cgPath
        layer0.shadowColor = UIColor(red: 0.227, green: 0.227, blue: 0.227, alpha: 0.3).cgColor
        layer0.shadowOpacity = 1
        layer0.shadowRadius = 8
        layer0.shadowOffset = CGSize(width: 0, height: 2)
        layer0.bounds = shadows.bounds
        layer0.position = shadows.center
        
        shadows.layer.addSublayer(layer0)
    }
    
    private func addShape()
    {
        let shapes = UIView()
        shapes.frame = self.frame
        shapes.clipsToBounds = true
        shapes.isUserInteractionEnabled = false
        
        self.addSubview(shapes)
        
        let layer1 = CALayer()
        layer1.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        layer1.bounds = shapes.bounds
        layer1.position = shapes.center
        
        shapes.layer.addSublayer(layer1)
        
        shapes.layer.cornerRadius = self.frame.height * 0.5
    }
    
    private func addImage()
    {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "FilterButton"))
//        imageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
//        imageView.clipsToBounds = true
        imageView.center = self.center
//        imageView.isUserInteractionEnabled = false
        
        self.addSubview(imageView)
    }
}
