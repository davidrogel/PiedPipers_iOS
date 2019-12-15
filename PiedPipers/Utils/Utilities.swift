//
//  Utilities.swift
//  PiedPipers
//
//  Created by david rogel pernas on 17/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

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

extension UIImage
{
//    public static func load2(withImgPath imgPath: String) -> Data?
//    {
//        if let url = String.createUrl(fromImgPath: imgPath)
//        {
//            return try? Data(contentsOf: url)
//        }
//
//        return nil
//    }

    public static func load(withImgPath imgPath: String, callback: @escaping (UIImage) -> Void)
    {
        // FIXME: Cuando se llega al Data da tirones y no carga bien aunque sea el fake Repo,
        // esto no puede ir aqui, tiene que ir en el presenter y el Presentable de turno tiene que tener una Data en vez de un String con el nombre de la imagen y su ruta
        
        DispatchQueue.main.async {
            if let url = String.createUrl(fromImgPath: imgPath)
            {
                if let img = try? UIImage(data: Data(contentsOf: url))
                {
                    callback(img)
                }
                else
                {
                    callback(UIImage(named: imgPath)!)
                }
            }
        }
        
        
        
        // Aquí se llegaría si no se consigue ejecutar lo de arriba, por lo que se generaría con o el "placeholder" o la imagen del fake que está en los assets
//        return UIImage(named: imgPath)!
    }
}

extension String
{
    public static func createUrl(fromImgPath imgPath: String) -> URL?
    {
        return URL(string: urlToServer + "/" + imgPath)
    }
}

extension UITextView {
    func calculeDescriptionViewHeight(leading: CGFloat, trailing: CGFloat) -> CGFloat{
        let width = UIScreen.main.bounds.width - leading - trailing
        let newSize = self.sizeThatFits(CGSize(width: width,
                                                   height: CGFloat.greatestFiniteMagnitude))
        return newSize.height + 50
    }
}
