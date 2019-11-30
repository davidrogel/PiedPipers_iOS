//
//  UIButton+ShadowsAndCornerRadius.swift
//  PiedPipers
//
//  Created by Jon Gonzalez on 17/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit

extension UIButton {
    
    func putShadowsAndRadiusWith(shadowColor: CGColor, shadowOffsetWidth: CGFloat, shadowOffsetHeight: CGFloat, shadowOpacity: Float, shadowRadius: CGFloat, cornerRadius: CGFloat) {
        
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        
        layer.shadowColor = shadowColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        
    }
}

