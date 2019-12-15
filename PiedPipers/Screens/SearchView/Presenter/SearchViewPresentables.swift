//
//  Presentables.swift
//  PiedPipers
//
//  Created by david rogel pernas on 03/12/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit

struct SearchProfilePresentable
{
    typealias Photo = String
    
    let cuid: String
    let profileName: String
    let friendlyLocation: String
    let image: Photo
    let instruments: [String]
}

struct SearchLocalPresentable
{
    typealias Photo = String
    
    let cuid: String
    let localName: String
    let price: String
    let description: String
    let image: Photo
}

extension SearchProfilePresentable
{
    static func make(cuid: String, name: String?, friendlyLocation: String?, photo: String?, instruments: [String]?) -> SearchProfilePresentable
    {
        return SearchProfilePresentable(cuid: cuid, profileName: name ?? "Name", friendlyLocation: friendlyLocation ?? "Somewhere", image: photo ?? "placeholder", instruments: instruments ?? [])
    }
}

extension SearchLocalPresentable
{
    static func make(cuid: String, name: String, price: Double, description: String, photos: [String]) -> SearchLocalPresentable
    {
        
        return SearchLocalPresentable(cuid: cuid, localName: name, price: price.toCurrency(), description: description, image: photos.first ?? "placeholder")
    }
}
