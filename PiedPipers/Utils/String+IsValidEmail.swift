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
        //let regex = try! NSRegularExpression(pattern: "^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$", options: .caseInsensitive)
        let regex = "^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        //return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
        return emailPredicate.evaluate(with: self)
    }
}
