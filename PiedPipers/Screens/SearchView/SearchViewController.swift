//
//  SearchViewController.swift
//  PiedPipers
//
//  Created by david rogel pernas on 23/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit

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
    
    // MARK: Presentable Zone
    
    private var presenter: SearchViewPresenter!
    
    let cuid = "ck2g3ps39000c93pcfox7e8jn"
    
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
            
            cell.setName(name: local.localName)
            
            let image:UIImage? = UIImage(named: local.image)
            if let img = image {
                cell.setPortrait(withImage: img)
            }
            
            cell.setPrice(price: local.price)
            cell.setDescription(text: local.description)
            
            return cell
        case .PROFILES:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellProfileId, for: indexPath) as! ProfileCustomCell
            
            let profile = profiles[indexPath.item]
            
            cell.setInstruments(instruments: profile.instruments)
            cell.setName(name: profile.profileName)
            cell.setFriendlyLocation(name: profile.friendlyLocation)
            
            let image:UIImage? = UIImage(named: profile.image)
            if let img = image {
                cell.setPortrait(withImage: img)
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: view.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected")
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
    func segmentedViewSegmentedIndexChanged(valueChanged value: Int)
    {
        errorView.isHidden = true
        nothingHereView.isHidden = true
        self.displayState = (value == 0) ? .PROFILES : .LOCALS
    }
    
    func searchBarSearchButtonPressed(valueToSearch value: String)
    {
        print("texto a buscar: \(value)")
        switch displayState
        {
        case .LOCALS:
            presenter.requestLocals(cuid: self.cuid, parameters: SearchLocalParameters(name: value), limit: 10, offset: 0)
        case .PROFILES:
            presenter.requestProfiles(cuid: self.cuid, parameters: SearchProfileParameters(name: value), limit: 10, offset: 0)
        }
    }
    
    func localFiltersParametersChanged(params: SearchLocalParameters)
    {
        
    }
    
    func profileFiltesParametersChanged(params: SearchProfileParameters)
    {
        
    }
}

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
