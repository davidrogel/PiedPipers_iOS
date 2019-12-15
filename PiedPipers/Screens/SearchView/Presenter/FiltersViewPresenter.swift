//
//  FiltersViewPresenter.swift
//  PiedPipers
//
//  Created by david rogel pernas on 14/12/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit

protocol FiltersViewDelegate: class
{
    func set(instruments: [String])
}

final class FiltersViewPresenter
{
    private unowned let filtersViewDelegate: FiltersViewDelegate
    private let repo:RepositoryFactory = Repository.remote
    
    init(filtersViewDelegate viewDelegate: FiltersViewDelegate)
    {
        filtersViewDelegate = viewDelegate
    }
    
    public func requestInstruments(cuid: String)
    {
        repo.getAvaliableInstruments(currentUserCUID: cuid, success: { [weak self] (instruments) in
            self?.sendInstruments(instruments: instruments ?? [])
        }) { (error) in
            
        }
    }
    
    private func sendInstruments(instruments: [String])
    {
        filtersViewDelegate.set(instruments: instruments)
    }
}
