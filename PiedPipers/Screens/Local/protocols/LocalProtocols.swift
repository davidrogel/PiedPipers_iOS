//
//  LocalProtocols.swift
//  PiedPipers
//
//  Created by Jon Gonzalez on 15/12/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Foundation

protocol LocalViewProtocol: AnyObject {
    func loadLocalData(with local: LocalPresentable)
    func showError()
}

protocol LocalPreseterProtocol: AnyObject {
    func getLocal(with cuid: String)
}
