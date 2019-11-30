//
//  SearchViewPresenter.swift
//  PiedPipers
//
//  Created by david rogel pernas on 21/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit

struct ProfilePresentable
{
    let profileName: String
}

struct LocalPresentable
{
    let localName: String
}

protocol SearchViewDelegate: class
{
    func showLoadingStatus()
    func hideLoadingStatus()
    func show(profiles: [ProfilePresentable])
    func show(locals: [LocalPresentable])
    func show(withErrorMessage errorMessage: String)
}

final class SearchViewPresenter
{
    private unowned let searchViewDelegate: SearchViewDelegate
    private let repo:RepositoryFactory = Repository.fake
    
//    private let currentUserCUID:String = {
//        return ""
//    }()
    
    let currentUserCUID:String = "ck2g2765h0000q64g4y8tfk0a"
    
    init(searchViewDelegate viewDelegate: SearchViewDelegate)
    {
        searchViewDelegate = viewDelegate
        
    }
    
    public func requestProfiles(cuid: String, parameters: SearchProfileParameters, limit: Int, offset: Int)
    {
        searchViewDelegate.showLoadingStatus()
        repo.searchProfiles(currentUserCUID: cuid, withParameters: parameters, limit: limit, offset: offset, success: {
            [weak self] (profileList) in
            
            guard let profiles = profileList else {
                self?.showErrorNotFound(withMsg: "Error 404!")
                return
            }
            self?.showProfiles(profileList: profiles)
            
        }) {
            [weak self] (error) in
            self?.showErrorNotFound(withMsg: "Error 404!")
        }
    }
    
    public func requestLocals(cuid: String, parameters: SearchLocalParameters, limit: Int, offset: Int)
    {
        searchViewDelegate.showLoadingStatus()
        repo.searchLocals(currentUserCUID: cuid, withParameters: parameters, limit: limit, offset: offset, success: {
            [weak self] (localList) in
            
            guard let locals = localList else {
                self?.showErrorNotFound(withMsg: "Error 404!")
                return
            }
            
            self?.showLocals(localList: locals)
            
        }) {
            [weak self] (error) in
            self?.showErrorNotFound(withMsg: "Error 404!")
        }
    }
    
    private func showErrorNotFound(withMsg msg: String)
    {
        searchViewDelegate.hideLoadingStatus()
        searchViewDelegate.show(withErrorMessage: msg)
    }
    
    private func showProfiles(profileList profiles: ProfileList)
    {
        let presentables:[ProfilePresentable] = profiles.items.map { (profile) -> ProfilePresentable in
            ProfilePresentable(profileName: profile.name!)
        }
        
        searchViewDelegate.hideLoadingStatus()
        searchViewDelegate.show(profiles: presentables)
    }
    
    private func showLocals(localList locals: LocalList)
    {
        let presentables:[LocalPresentable] = locals.items.map { (local) -> LocalPresentable in
            LocalPresentable(localName: local.name)
        }
        
        searchViewDelegate.hideLoadingStatus()
        searchViewDelegate.show(locals: presentables)
    }
}
