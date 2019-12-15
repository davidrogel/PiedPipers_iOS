//
//  LocalPresenter.swift
//  PiedPipers
//
//  Created by Jon Gonzalez on 15/12/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Foundation
import CoreLocation

class LocalPresenter {
    public private(set) weak var ui: LocalViewProtocol?
    public private(set) var localService: RepositoryFactory
    
    init(with ui: LocalViewProtocol, localService: RepositoryFactory) {
        self.ui = ui
        self.localService = localService
    }
}

extension LocalPresenter: LocalPreseterProtocol {
    
    func getLocal(with cuid: String) {
        localService.getLocal(withCUID: cuid, success: { [weak self] (local) in
            guard let localUnwrapped = local else {
                fatalError()
            }
            guard let localPresentable = self?.convert2LocalPresentable(local: localUnwrapped) else {
                fatalError()
            }
            self?.ui?.loadLocalData(with: localPresentable)
        }, failure: { [weak self] (error) in
            //TODO
        })
    }
}

extension LocalPresenter {
    func convert2LocalPresentable(local: Local) -> LocalPresentable {
        let contactPresentable = ContactPresentable(type: local.contact.type, data: local.contact.data)
        let localPresentable = LocalPresentable(name: local.name, price: local.price, location: local.location, contact: contactPresentable, description: local.description, photos: local.photos)
        
        return localPresentable
    }
    
    func lookUpLocation(with location: CLLocation, completionHandler: @escaping (CLPlacemark?)
                    -> Void ) {
        let geocoder = CLGeocoder()
        
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(location,
                                        completionHandler: { (placemarks, error) in
                                            if error == nil {
                                                let firstLocation = placemarks?[0]
                                                completionHandler(firstLocation)
                                            }
                                            else {
                                                // An error occurred during geocoding.
                                                completionHandler(nil)
                                            }
        })
    }
}
