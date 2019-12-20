//
//  HomeViewPresenter.swift
//  PiedPipers
//
//  Created by david rogel pernas on 18/12/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit

typealias HomeLocalPresentable = SearchLocalPresentable
typealias HomeProfilePresentable = SearchProfilePresentable

protocol HomeViewDelegate: class
{
    func hideLocals()
    func hideBand()
    func show(locals: [HomeLocalPresentable])
    func show(bandProfiles: [HomeProfilePresentable])
}

final class HomeViewPresenter
{
    private unowned let homeViewDelegate: HomeViewDelegate
    private let repo:RepositoryFactory = Repository.remote
    
    init(homeViewDelegate viewDelegate: HomeViewDelegate)
    {
        self.homeViewDelegate = viewDelegate
    }
    
    public func requestLocals(cuid: String, limit: Int, offset: Int)
    {
        repo.searchLocals(currentUserCUID: cuid, withParameters: SearchLocalParameters(), limit: limit, offset: offset, success: {
            [weak self] (localList) in
            
            guard let locals = localList else {
//                self?.showErrorNotFound(withMsg: "Error 404!")
                self?.homeViewDelegate.hideLocals()
                return
            }
            
            self?.showLocals(localList: locals)
        }) {
            [weak self] (error) in
//            self?.showErrorNotFound(withMsg: "Error 404!")
        }
    }
    
    public func requestBand(currentUserCuid cuid: String)
    {
        homeViewDelegate.show(bandProfiles: [HomeProfilePresentable(cuid: "", profileName: "name", friendlyLocation: "here", image: "kojima", instruments: ["zambomba", "guitarra"]),
                                             HomeProfilePresentable(cuid: "", profileName: "name", friendlyLocation: "here", image: "kojima", instruments: ["zambomba", "guitarra"]),
                                             HomeProfilePresentable(cuid: "", profileName: "name", friendlyLocation: "here", image: "kojima", instruments: ["zambomba", "guitarra"]),
                                             HomeProfilePresentable(cuid: "", profileName: "name", friendlyLocation: "here", image: "kojima", instruments: ["zambomba", "guitarra"])])
        return
        repo.getProfileBand(currentUserCUID: cuid, success: {
            [weak self] (profileList) in
            
            guard let profiles = profileList else {
                self?.homeViewDelegate.hideLocals()
                // all bad
                return
            }
            
            // all good
            
        }) { (error) in
            // too bad
        }
    }
    
    private func showLocals(localList locals: LocalList)
    {
        let presentables:[HomeLocalPresentable] = locals.items.map { (local) -> HomeLocalPresentable in
            HomeLocalPresentable.make(cuid: local.cuid, name: local.name, price: local.price, description: local.description, photos: local.photos)
        }
        
        homeViewDelegate.show(locals: presentables)
    }
}
