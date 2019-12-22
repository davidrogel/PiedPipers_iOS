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
        localService.getLocalById(localCuid: cuid, success: { [weak self] (local) in
            guard let localUnwrapped = local else {
                self?.ui?.showError()
                return
            }
            guard let localPresentable = self?.convert2LocalPresentable(local: localUnwrapped) else {
                self?.ui?.showError()
                return
            }
            self?.ui?.loadLocalData(with: localPresentable)
        }, failure: { [weak self] (error) in
            self?.ui?.showError()
        })
    }
}

extension LocalPresenter {
    func convert2LocalPresentable(local: Local) -> LocalPresentable {
        let contactPresentable = ContactPresentable(type: local.contact.type, data: local.contact.data)
        let localPresentable = LocalPresentable(name: local.name, price: local.price, location: local.location, contact: contactPresentable, description: local.description, photos: local.photos)
        
        return localPresentable
    }
}
