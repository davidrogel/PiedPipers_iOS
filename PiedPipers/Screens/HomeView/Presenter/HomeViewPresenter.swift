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
                self?.homeViewDelegate.hideLocals()
                return
            }
            
            self?.showLocals(localList: locals)
        }) { (error) in
            
        }
    }
    
    public func requestBand(currentUserCuid cuid: String)
    {
        repo.getProfileBand(currentUserCUID: cuid, success: {
            [weak self] (profileList) in
            
            guard let profiles = profileList else {
                self?.homeViewDelegate.hideLocals()
                // all bad
                return
            }
            self?.showBand(profileList: profiles)
            // all good
            
        }) { (error) in
            // too bad
        }
    }
    
    private func showLocals(localList locals: LocalList)
    {
        let presentables:[HomeLocalPresentable] = locals.items.map { (local) -> HomeLocalPresentable in
            HomeLocalPresentable.make(cuid: local.cuid, name: local.name, price: local.price, description: local.shortDescription, photos: local.photos)
        }
        
        homeViewDelegate.show(locals: presentables)
    }
    
    private func showBand(profileList profiles: ProfileList)
    {
        let presentables:[HomeProfilePresentable] = profiles.items.map { (profile) -> HomeProfilePresentable in
            HomeProfilePresentable.make(cuid: profile.cuid, name: profile.name, friendlyLocation: profile.friendlyLocation, photo: profile.photo, instruments: profile.instruments)
        }
        
        homeViewDelegate.show(bandProfiles: presentables)
    }
}
