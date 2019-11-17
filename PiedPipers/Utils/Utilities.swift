//
//  Utilities.swift
//  PiedPipers
//
//  Created by david rogel pernas on 17/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Foundation

enum Fmt
{
    static func currency() -> NumberFormatter
    {
        return NumberFormatter()
    }
}

// Esto sirve por ahora pero habría que extraerlo y montar una clase más bonika
extension Double
{
    func toCurrency() -> String
    {
        let numberFormatter = NumberFormatter()
        // para mostrar el punto o coma en los miles
        numberFormatter.usesGroupingSeparator = true
        // muestra siempre el dimal aunque sea un integer, ej: 100,00
        numberFormatter.alwaysShowsDecimalSeparator = true
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current

        guard let currencyStr = numberFormatter.string(from: NSNumber(value: self)) else
        {
            return String.init(format: "%.2f", locale: .current, self)
        }
        
        return currencyStr
    }
}

extension AnyHashable
{
    public static func == (lhs: AnyHashable, rhs: String) -> Bool
    {
        return lhs.description == rhs
    }
}
