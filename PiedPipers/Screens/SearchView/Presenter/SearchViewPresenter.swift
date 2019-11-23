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
    
    lazy var currentUserCUID:String = "ck2g2765h0000q64g4y8tfk0a"
    
    init(searchViewDelegate viewDelegate: SearchViewDelegate)
    {
        searchViewDelegate = viewDelegate
        
//        repo.searchProfiles(currentUserCUID: "", withParameters: SearchProfileParameters(),
//                            limit: 0, offset: 0, success: { (profileList) in
//            guard let profiles = profileList else { fatalError() }
//
//            self.searchViewDelegate.show(profiles: profiles.items.map({ (profile) -> ProfilePresentable in
//                ProfilePresentable(profileName: profile.name!)
//            }))
//
//        }) { (err) in
//            fatalError()
//        }
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
    
    public func requestLocals()
    {
        
    }
    
    fileprivate func showErrorNotFound(withMsg msg: String)
    {
        searchViewDelegate.hideLoadingStatus()
        searchViewDelegate.show(withErrorMessage: msg)
    }
    
    fileprivate func showProfiles(profileList profiles: ProfileList)
    {
        let presentables:[ProfilePresentable] = profiles.items.map { (profile) -> ProfilePresentable in
            ProfilePresentable(profileName: profile.name!)
        }
        
        searchViewDelegate.hideLoadingStatus()
        searchViewDelegate.show(profiles: presentables)
    }
}
