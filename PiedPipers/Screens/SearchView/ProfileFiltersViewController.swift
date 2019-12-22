//
//  ProfileFiltersViewController.swift
//  PiedPipers
//
//  Created by david rogel pernas on 10/12/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit

protocol ProfileFiltersProtocol
{
    func applyProfileFilters(filters: SearchProfileParameters)
}

final class ProfileFiltersViewController : UIViewController
{
    // MARK: - Views
    
    private let closeBtn:UIButton = {
        let btn = FilterButton(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        btn.addImage(image: #imageLiteral(resourceName: "Close"))
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(closeFilters), for: .touchUpInside)
        return btn
    }()
    
    private let filtersLbl:UILabel = {
        let lbl = UILabel()
        lbl.text = "Filters"
        lbl.font = UIFont.boldSystemFont(ofSize: 24)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let instrumentsLbl:UILabel = {
        let lbl = UILabel()
        lbl.text = "Instruments"
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let addInstrumentBtn:UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.contactAdd)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(addInstrument), for: .touchUpInside)
        return btn
    }()
    
    private let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 8
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        return cv
    }()
    
    // MARK: - Parameters
    
    var delegate:ProfileFiltersProtocol? = nil
    
    private var filters:SearchProfileParameters = SearchProfileParameters()
    
    private var allAvailableInstruments:[String] = []
    
    private let cellId = "cellId"
    
    private let cuid = StoreManager.shared.getLoggedUser()
    
    // MARK: - Presenter
    
    private var presenter: FiltersViewPresenter!
    
    // MARK: - Functions
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        presenter = FiltersViewPresenter(filtersViewDelegate: self)
        presenter.requestInstruments(cuid: cuid)
        
        configure()
    }
    
    private func configure()
    {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(InstrumentPickedCustomCell.self, forCellWithReuseIdentifier: cellId)
        
        view.addSubview(closeBtn)
        view.addSubview(filtersLbl)
        view.addSubview(instrumentsLbl)
        view.addSubview(addInstrumentBtn)
        view.addSubview(collectionView)
        
        configureCloseButtonConstraints()
        configureFiltersLabelConstraints()
        configureInstrumentsLabelConstraints()
        configureAddInstrumentButtonConstraints()
        configureCollectionViewConstraints()
    }
    
    @objc func closeFilters()
    {
        delegate?.applyProfileFilters(filters: filters)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addInstrument()
    {
        let vc = InstrumentsPickerViewController(with: allAvailableInstruments)
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    public func setFilters(filters: SearchProfileParameters)
    {
        
        self.filters = filters
    }
}

extension ProfileFiltersViewController : InstrumentsPickerViewDelegate
{
    func addSelectedInstrument(withName instrument: String)
    {
        print("instrument to append: \(instrument)")
        if filters.instruments == nil
        {
            filters.instruments = []
        }
        filters.instruments?.append(instrument)
        collectionView.reloadData()
    }
}

extension ProfileFiltersViewController : FiltersViewDelegate
{
    func set(instruments: [String])
    {
        print("setInstrument from presenter \(instruments)")
        self.allAvailableInstruments = instruments
    }
}

extension ProfileFiltersViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return filters.instruments?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! InstrumentPickedCustomCell
        
        cell.setText(withName: filters.instruments?[indexPath.item] ?? "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        let spacing:CGFloat = 32.0
        let totalWidth = UIScreen.main.bounds.width - 16.0
        
        return CGSize(width: (totalWidth - spacing) / 3.0, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        filters.instruments?.remove(at: indexPath.item)
        collectionView.deleteItems(at: [indexPath])
    }
}

// MARK: - Constraints
extension ProfileFiltersViewController
{
    private func configureCloseButtonConstraints()
    {
        closeBtn.heightAnchor.constraint(equalToConstant: 48).isActive = true
        closeBtn.widthAnchor.constraint(equalTo: closeBtn.heightAnchor, multiplier: 1).isActive = true
        closeBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        closeBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        closeBtn.leadingAnchor.constraint(equalTo: filtersLbl.trailingAnchor, constant: 16).isActive = true
    }
    
    private func configureFiltersLabelConstraints()
    {
        filtersLbl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        filtersLbl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24).isActive = true
        filtersLbl.trailingAnchor.constraint(equalTo: closeBtn.leadingAnchor, constant: -16).isActive = true
        filtersLbl.centerYAnchor.constraint(equalTo: closeBtn.centerYAnchor).isActive = true
    }
    
    private func configureInstrumentsLabelConstraints()
    {
        instrumentsLbl.topAnchor.constraint(equalTo: closeBtn.bottomAnchor, constant: 32).isActive = true
        instrumentsLbl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24).isActive = true
//        instrumentsLbl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
//        instrumentsLbl.trailingAnchor.constraint(equalTo: addInstrumentBtn.trailingAnchor, constant: -16).isActive = true
    }
    
    private func configureAddInstrumentButtonConstraints()
    {
        addInstrumentBtn.leadingAnchor.constraint(equalTo: instrumentsLbl.trailingAnchor, constant: 16).isActive = true
//        addInstrumentBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
        addInstrumentBtn.centerYAnchor.constraint(equalTo: instrumentsLbl.centerYAnchor).isActive = true
//        addInstrumentBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        addInstrumentBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    private func configureCollectionViewConstraints()
    {
        collectionView.topAnchor.constraint(equalTo: instrumentsLbl.bottomAnchor, constant: 8).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
}

class InstrumentPickedCustomCell: UICollectionViewCell
{
    private let lbl:UILabel = {
        let i = UILabel()
        i.layer.cornerRadius = 14
        i.textAlignment = .center
        i.textColor = .white
        i.layer.backgroundColor = UIColor(red: 0.514, green: 0.557, blue: 0.871, alpha: 1).cgColor
        i.translatesAutoresizingMaskIntoConstraints = false
        return i
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        addSubview(lbl)
        lbl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        lbl.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        lbl.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        lbl.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
    
    public func setText(withName name: String)
    {
        lbl.text = name
    }
}
