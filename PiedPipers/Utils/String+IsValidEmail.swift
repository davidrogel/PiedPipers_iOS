//
//  String+IsValidEmail.swift
//  PiedPipers
//
//  Created by Jon Gonzalez on 01/12/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        let regex = "^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        //return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
        return emailPredicate.evaluate(with: self)
    }
    
    func isValidPhone() -> Bool {
        let regex = "(([+][(]?[0-9]{1,3}[)]?)|([(]?[0-9]{4}[)]?))\\s*[)]?[-\\s\\.]?[(]?[0-9]{1,3}[)]?([-\\s\\.]?[0-9]{3})([-\\s\\.]?[0-9]{3,4})"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        //return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
        return phonePredicate.evaluate(with: self)
    }
}
