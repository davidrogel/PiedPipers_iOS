//
//  HomeViewController.swift
//  PiedPipers
//
//  Created by david rogel pernas on 18/12/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit

typealias BandProfileCustomCell = ProfileCustomCell

class HomeViewController: UIViewController
{
    // MARK: - Views
    private let logoImageView: UIImageView = {
        let imgView = UIImageView(image: #imageLiteral(resourceName: "Tuned-Logo.png"))
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    private let localsTitleLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Where to play near to you"
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let yourBandTitleLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Your band!"
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let localsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.clipsToBounds = false
        return cv
    }()
    
    private let bandCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.clipsToBounds = false
        return cv
    }()
    
    // MARK: - Parameters
    
    private let cellBandProfileId = "cellBandProfileId"
    private let cellLocalId = "cellLocalId"
    
    private var presenter: HomeViewPresenter!
    
    // TODO: Quitar esto de aqui y coger el que debería estar cacheado
    let cuid = "ck2g3ps39000c93pcfox7e8jn"
    
    // MARK: Presentables
    
    private var bandProfiles: [HomeProfilePresentable] = []
    {
        didSet
        {
            bandCollectionView.reloadData()
        }
    }
    
    private var locals: [HomeLocalPresentable] = []
    {
        didSet
        {
            localsCollectionView.reloadData()
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
        presenter = HomeViewPresenter(homeViewDelegate: self)
        
        presenter.requestLocals(cuid: cuid, limit: 10, offset: 0)
        
//        localsCollectionView.tag = 1
//        bandCollectionView.tag = 2
        
        localsCollectionView.dataSource = self
        bandCollectionView.dataSource = self
        
        localsCollectionView.delegate = self
        bandCollectionView.delegate = self
        
        localsCollectionView.backgroundColor = .white
        bandCollectionView.backgroundColor = .white
        
        bandCollectionView.register(BandProfileCustomCell.self, forCellWithReuseIdentifier: cellBandProfileId)
        localsCollectionView.register(LocalCustomCell.self, forCellWithReuseIdentifier: cellLocalId)
        
        view.addSubview(logoImageView)
        view.addSubview(localsTitleLbl)
        view.addSubview(yourBandTitleLbl)
//        view.addSubview(bandCollectionView)
        view.addSubview(localsCollectionView)
        
        configureLogoImageViewConstraints()
        configureLocalsTitleLabelConstraints()
        configureYourBandTitleLabelConstraints()
        
        configureLocalsCollectionViewConstraints()
    }
}

// MARK: - DataSource and Delegate
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return collectionView === localsCollectionView ? locals.count : bandProfiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView === localsCollectionView
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellLocalId, for: indexPath) as! LocalCustomCell
            
            let local = locals[indexPath.item]
            
            cell.fill(withLocalPresentable: local)
            
            return cell
        }
        else if collectionView === bandCollectionView
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellBandProfileId, for: indexPath) as! BandProfileCustomCell
            
            let bandProfile = bandProfiles[indexPath.item]
            
            cell.fill(withProfilePresentable: bandProfile)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: view.frame.width * 0.8, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print("selected")
    }
}

// MARK: - DelegateView Presenter
extension HomeViewController: HomeViewDelegate
{
    func show(locals: [HomeLocalPresentable])
    {
        if locals.count > 0
        {
            self.locals = locals
        }
    }
    
    func show(bandProfiles: [HomeProfilePresentable])
    {
        if bandProfiles.count > 0
        {
            self.bandProfiles = bandProfiles
        }
    }
}

// MARK: - Constraints
extension HomeViewController
{
    private func configureLogoImageViewConstraints()
    {
        logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
    
    private func configureLocalsTitleLabelConstraints()
    {
        localsTitleLbl.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16).isActive = true
        localsTitleLbl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
    
    private func configureYourBandTitleLabelConstraints()
    {
        yourBandTitleLbl.topAnchor.constraint(equalTo: localsCollectionView.bottomAnchor, constant: 16).isActive = true
        yourBandTitleLbl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
    
    private func configureLocalsCollectionViewConstraints()
    {
        localsCollectionView.clipsToBounds = false
        localsCollectionView.topAnchor.constraint(equalTo: localsTitleLbl.bottomAnchor, constant: 8).isActive = true
        localsCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        localsCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
//        localsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        localsCollectionView.heightAnchor.constraint(equalToConstant: 250).isActive = true
    }
}
