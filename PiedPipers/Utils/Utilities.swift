//
//  Utilities.swift
//  PiedPipers
//
//  Created by david rogel pernas on 17/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Foundation
import UIKit

// Darle una vuelta (O₂)
fileprivate enum Fmt
{
    static func currency() -> NumberFormatter
    {
        let numberFormatter = NumberFormatter()
        // para mostrar el punto o coma en los miles
        numberFormatter.usesGroupingSeparator = true
        // muestra siempre el dimal aunque sea un integer, ej: 100,00
        numberFormatter.alwaysShowsDecimalSeparator = true
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        
        return numberFormatter
    }
    
    static func datetime() -> DateFormatter
    {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone.current
        
        return dateFormatter
    }
}

// esto estaría bien que no dependiese del Double para obtener la currency
extension Double
{
    func toCurrency() -> String
    {
        guard let currencyStr = Fmt.currency().string(from: NSNumber(value: self)) else
        {
            return String.init(format: "%.2f", locale: .current, self)
        }
        
        return currencyStr
    }
}

extension Date
{
    static func date(from string: String) -> Date?
    {
        return Fmt.datetime().date(from: string)
    }
}

extension AnyHashable
{
    public static func == (lhs: AnyHashable, rhs: String) -> Bool
    {
        return lhs.description == rhs
    }
}

extension UIStackView
{
    func addArrangedSubviews(_ views: [UIView])
    {
        views.forEach{ self.addArrangedSubview($0) }
    }
}

extension String
{
    public static func createUrl(fromImgPath imgPath: String) -> URL?
    {
        return URL(string: urlToServer + "/" + imgPath)
    }
}

extension UIImage
{
    public func resize(size: CGSize) -> UIImage?
    {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
