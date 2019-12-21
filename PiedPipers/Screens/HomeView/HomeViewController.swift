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
    private let scrollView = UIScrollView()
    
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
        
        let currentUserCuid = StoreManager.shared.getLoggedUser()
        
        presenter.requestLocals(cuid: currentUserCuid, limit: 10, offset: 0)
        presenter.requestBand(currentUserCuid: currentUserCuid)
        
        localsCollectionView.dataSource = self
        bandCollectionView.dataSource = self
        
        localsCollectionView.delegate = self
        bandCollectionView.delegate = self
        
        localsCollectionView.backgroundColor = .white
        bandCollectionView.backgroundColor = .white
        
        bandCollectionView.register(BandProfileCustomCell.self, forCellWithReuseIdentifier: cellBandProfileId)
        localsCollectionView.register(LocalCustomCell.self, forCellWithReuseIdentifier: cellLocalId)
        
        scrollView.backgroundColor = .white
        
        scrollView.addSubview(logoImageView)
        scrollView.addSubview(localsTitleLbl)
        scrollView.addSubview(localsCollectionView)
        scrollView.addSubview(yourBandTitleLbl)
        scrollView.addSubview(bandCollectionView)
        
        view.addSubview(scrollView)
        
//        view.addSubview(logoImageView)
//        view.addSubview(localsTitleLbl)
//        view.addSubview(yourBandTitleLbl)
//        view.addSubview(bandCollectionView)
//        view.addSubview(localsCollectionView)
        
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        
        configureLogoImageViewConstraints()
        
        configureLocalsTitleLabelConstraints()
        configureYourBandTitleLabelConstraints()
        
        configureLocalsCollectionViewConstraints()
        configureBandCollectionViewConstraints()
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
        if collectionView === localsCollectionView
        {
            print("selected local")
            let cuid = locals[indexPath.item].cuid
            let vc = Assembler.provideLocalDetailView(withCuid: cuid)
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
        else if collectionView === bandCollectionView
        {
            print("selected band profile")
            let cuid = bandProfiles[indexPath.item].cuid
            let vc = Assembler.provideUserProfile(with: cuid, status: .other)
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
}

// MARK: - DelegateView Presenter
extension HomeViewController: HomeViewDelegate
{
    func hideLocals() {
        localsCollectionView.isHidden = true
    }
    
    func hideBand() {
        bandCollectionView.isHidden = true
    }
    
    func show(locals: [HomeLocalPresentable])
    {
        if locals.count > 0
        {
            localsCollectionView.isHidden = false
            self.locals = locals
        }
    }
    
    func show(bandProfiles: [HomeProfilePresentable])
    {
        if bandProfiles.count > 0
        {
            bandCollectionView.isHidden = false
            self.bandProfiles = bandProfiles
        }
    }
}

// MARK: - Constraints
extension HomeViewController
{
    private func configureLogoImageViewConstraints()
    {
        let safe = view.safeAreaLayoutGuide
        logoImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    }
    
    private func configureLocalsTitleLabelConstraints()
    {
        
        let safe = view.safeAreaLayoutGuide
        localsTitleLbl.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16).isActive = true
        localsTitleLbl.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 24).isActive = true
//        localsTitleLbl.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    }
    
    private func configureYourBandTitleLabelConstraints()
    {
        
        let safe = view.safeAreaLayoutGuide
        yourBandTitleLbl.topAnchor.constraint(equalTo: localsCollectionView.bottomAnchor, constant: 16).isActive = true
        yourBandTitleLbl.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 24).isActive = true
//        yourBandTitleLbl.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    }
    
    private func configureLocalsCollectionViewConstraints()
    {
        let safe = view.safeAreaLayoutGuide
        localsCollectionView.topAnchor.constraint(equalTo: localsTitleLbl.bottomAnchor, constant: 8).isActive = true
        localsCollectionView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 8).isActive = true
        localsCollectionView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -8).isActive = true
        localsCollectionView.bottomAnchor.constraint(equalTo: yourBandTitleLbl.topAnchor, constant: -16).isActive = true
        localsCollectionView.heightAnchor.constraint(equalToConstant: 250).isActive = true
    }
    
    private func configureBandCollectionViewConstraints()
    {
        let safe = view.safeAreaLayoutGuide
        bandCollectionView.topAnchor.constraint(equalTo: yourBandTitleLbl.bottomAnchor, constant: 8).isActive = true
        bandCollectionView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 8).isActive = true
        bandCollectionView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -8).isActive = true
        bandCollectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -8).isActive = true
        bandCollectionView.heightAnchor.constraint(equalToConstant: 250).isActive = true
    }
}
