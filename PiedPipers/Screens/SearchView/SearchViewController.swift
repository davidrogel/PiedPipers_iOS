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
    
    private let cellId = "cellId"
    
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
        
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: cellId)
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: view.frame.width, height: 300)
    }
}

class CustomCell: UICollectionViewCell
{
    let portrait:UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "kojima"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 24
        return iv
    }()
    
    let dataView:UIView = {
        let v = UIView()
        v.backgroundColor = .systemBlue
        v.layer.cornerRadius = 24
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        addSubview(portrait)
        addSubview(dataView)
        
        portrait.translatesAutoresizingMaskIntoConstraints = false

        portrait.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
//        portrait.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -60).isActive = true
        portrait.bottomAnchor.constraint(equalTo: dataView.centerYAnchor).isActive = true
        portrait.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        portrait.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        
        
        dataView.heightAnchor.constraint(equalToConstant: 85).isActive = true
        dataView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dataView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        dataView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
    
    public func setPortrait(withImage image: UIImage)
    {
        portrait.image = image
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
            nothingHereView.label.text = "Nothing was found"
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
    func profileFiltesParametersChanged(params: SearchProfileParameters)
    {
        
    }
     
    func segmentedViewSegmentedIndexChanged(valueChanged value: Int)
    {
        self.displayState = (value == 0) ? .PROFILES : .LOCALS
    }
    
    func searchBarSearchButtonPressed(valueToSearch value: String)
    {
        print("texto a buscar: \(value)")
        switch displayState
        {
        case .LOCALS:
            presenter.requestLocals(cuid: "", parameters: SearchLocalParameters(), limit: 0, offset: 0)
        case .PROFILES:
            presenter.requestProfiles(cuid: "", parameters: SearchProfileParameters(), limit: 0, offset: 0)
        }
    }
    
    func localFiltersParametersChanged(params: SearchLocalParameters)
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
