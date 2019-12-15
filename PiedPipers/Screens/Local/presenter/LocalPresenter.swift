//
//  LocalPresenter.swift
//  PiedPipers
//
//  Created by Jon Gonzalez on 15/12/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Foundation

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
        //TODO
    }
    
}
