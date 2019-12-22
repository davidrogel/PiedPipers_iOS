//
//  SearchViewController.swift
//  PiedPipers
//
//  Created by david rogel pernas on 23/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit
import Kingfisher

class SearchViewController: UIViewController
{
    // MARK: - Views & Controlls
    
    private let topView:TopView = TopView()
    
    private let collectionView:UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let loadingView:LoadingView = LoadingView()
    
    // MARK: Errors and Not founds
    
    private let nothingHereView:NotFoundView = NotFoundView()
    private let errorView:NotFoundView = NotFoundView()
    
    // MARK: - Parameters
    
    private let cellProfileId = "cellProfileId"
    private let cellLocalId = "cellLocalId"
    
    enum DisplayState { case LOCALS, PROFILES }
    private var displayState: DisplayState = .LOCALS
    {
        didSet
        {
            collectionView.reloadData()
        }
    }
    
    // MARK: - Filters
    
    private var profileFilters:SearchProfileParameters = SearchProfileParameters()
    private var localFilters:SearchLocalParameters = SearchLocalParameters()
    
    // MARK: Presentable Zone
    
    private var presenter: SearchViewPresenter!
    
    private var cuid: String = StoreManager.shared.getLoggedUser()
    
    var profiles: [SearchProfilePresentable] = []
    {
        didSet
        {
            // actualizar la lista
            collectionView.reloadData()
        }
    }
    
    var locals: [SearchLocalPresentable] = []
    {
        didSet
        {
            // actualizar la lista
            collectionView.reloadData()
        }
    }
    
    // MARK: - Functions
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setup()
    }
    
    private func setup()
    {
        presenter = SearchViewPresenter(searchViewDelegate: self)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(ProfileCustomCell.self, forCellWithReuseIdentifier: cellProfileId)
        collectionView.register(LocalCustomCell.self, forCellWithReuseIdentifier: cellLocalId)
        
        collectionView.backgroundColor = .white
        
        topView.delegate = self
        
        displayState = .PROFILES
        
        nothingHereView.isHidden = true
        errorView.isHidden = true
        loadingView.isHidden = true
        
        view.addSubview(topView)
        view.addSubview(collectionView)
        view.addSubview(nothingHereView)
        view.addSubview(errorView)
        view.addSubview(loadingView)
        
        // main views Constraints
        configureTopViewConstraints()
        configureCollectionViewConstraints()
        
        // loading view Constraints
        configureLoadingConstraints()
    
        // error and nothing-here Views Constraints
        configureNothingHereConstraints()
        configureErrorViewConstraints()
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return (displayState == .LOCALS) ? locals.count : profiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        switch displayState
        {
        case .LOCALS:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellLocalId, for: indexPath) as! LocalCustomCell
            
            let local = locals[indexPath.item]
            
            cell.fill(withLocalPresentable: local)
            
            return cell
        case .PROFILES:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellProfileId, for: indexPath) as! ProfileCustomCell
            
            let profile = profiles[indexPath.item]
            
            cell.fill(withProfilePresentable: profile)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: view.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print("selected")
        switch displayState
        {
        case .LOCALS:
            let cuid = locals[indexPath.item].cuid
            let vc = Assembler.provideLocalDetailView(withCuid: cuid)
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        case .PROFILES:
            let cuid = profiles[indexPath.item].cuid
            let vc = Assembler.provideUserProfile(with: cuid, status: .other)
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
}

/// Delegate implemented to work with Presenter
extension SearchViewController: SearchViewDelegate
{
    func showLoadingStatus()
    {
        loadingView.showAndStartAnimate()
    }
    
    func hideLoadingStatus()
    {
        loadingView.hideAndStopAnimate()
    }
    
    func show(profiles: [SearchProfilePresentable])
    {
        if profiles.isEmpty
        {
            nothingHereView.isHidden = false
            nothingHereView.label.text = "Nothing found"
            return
        }
        
        errorView.isHidden = true
        nothingHereView.isHidden = true
        self.profiles = profiles
    }
    
    func show(locals: [SearchLocalPresentable])
    {
        if locals.isEmpty
        {
            nothingHereView.isHidden = false
            nothingHereView.label.text = "Nothing found"
            return
        }
        errorView.isHidden = true
        nothingHereView.isHidden = true
        self.locals = locals
    }
    
    func show(withErrorMessage errorMessage: String)
    {
        errorView.label.text = errorMessage
        errorView.isHidden = false
    }
}

/// Delegate implemented to work with TopView
extension SearchViewController: TopViewDelegate
{
    // MARK: Swap views
    func segmentedViewSegmentedIndexChanged(valueChanged value: Int)
    {
        errorView.isHidden = true
        nothingHereView.isHidden = true
        self.displayState = (value == 0) ? .PROFILES : .LOCALS
    }
    // MARK: Searching after Search Button tap
    func searchBarSearchButtonPressed(valueToSearch value: String)
    {
        print("texto a buscar: \(value)")
        switch displayState
        {
        case .LOCALS:
            localFilters.name = value
            presenter.requestLocals(cuid: self.cuid, parameters: localFilters, limit: 10, offset: 0)
        case .PROFILES:
            profileFilters.name = value
            presenter.requestProfiles(cuid: self.cuid, parameters: profileFilters, limit: 10, offset: 0)
        }
    }
    // MARK: Filters Presentation
    func openFiltersViewController()
    {
        switch displayState
        {
        case .LOCALS:
            presentLocalFilters()
        case .PROFILES:
            presentProfileFilters()
        }
    }
    
    private func presentProfileFilters()
    {
        let vc = ProfileFiltersViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        // aplicamos los filtros que ya existen
        vc.setFilters(filters: profileFilters)
        present(vc, animated: true, completion: nil)
    }
    
    private func presentLocalFilters()
    {
        let vc = LocalFiltersViewController()
        vc.delegate = self
        vc.setFilters(filters: localFilters)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

// MARK: - Apply filters
extension SearchViewController: ProfileFiltersProtocol
{
    func applyProfileFilters(filters: SearchProfileParameters)
    {
        if let friendlyLocation = filters.friendlyLocation
        {
            profileFilters.friendlyLocation = friendlyLocation
        }
        
        if let instruments = filters.instruments
        {
            profileFilters.instruments = instruments
        }
        
        if let lat = filters.lat, let long = filters.long
        {
            profileFilters.lat = lat
            profileFilters.long = long
        }
        
        presenter.requestProfiles(cuid: cuid, parameters: profileFilters, limit: 10, offset: 0)
    }
}

extension SearchViewController: LocalFiltersProtocol
{
    func applyLocalFilters(filters: SearchLocalParameters)
    {
        if let price = filters.price
        {
            localFilters.price = price
        }
        
        if let lat = filters.lat, let long = filters.long
        {
            localFilters.lat = lat
            localFilters.long = long
        }
        
        presenter.requestLocals(cuid: cuid, parameters: localFilters, limit: 10, offset: 0)
    }
}

// MARK: - Constraints
extension SearchViewController
{
    private func configureLoadingConstraints()
    {
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        loadingView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        loadingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    private func configureNothingHereConstraints()
    {
        nothingHereView.translatesAutoresizingMaskIntoConstraints = false
        
        nothingHereView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        nothingHereView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        nothingHereView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        nothingHereView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    private func configureErrorViewConstraints()
    {
        errorView.translatesAutoresizingMaskIntoConstraints = false
        
        errorView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        errorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        errorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        errorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    private func configureTopViewConstraints()
    {
        topView.translatesAutoresizingMaskIntoConstraints = false
        
        topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        topView.bottomAnchor.constraint(equalTo: collectionView.topAnchor).isActive = true
        topView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        topView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    }
    
    private func configureCollectionViewConstraints()
    {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
}
