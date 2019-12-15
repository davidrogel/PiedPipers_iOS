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
//        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let btn = UIButton(type: UIButton.ButtonType.contactAdd)
//        btn.setTitle("Add", for: .normal)
//        btn.setTitleColor(.black, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(addInstrument), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Parameters
    
    var delegate:ProfileFiltersProtocol? = nil
    
    private var filters:SearchProfileParameters = SearchProfileParameters()
    
    public func setFilters(filters: SearchProfileParameters)
    {
        self.filters = filters
    }
    
    private var instruments:[String] = []
    {
        didSet
        {
            // collection.reloadData()
        }
    }
    
    // TODO: Quitar esto de aqui y coger el que debería estar cacheado
    let cuid = "ck2g3ps39000c93pcfox7e8jn"
    
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
        view.addSubview(closeBtn)
        view.addSubview(filtersLbl)
        view.addSubview(instrumentsLbl)
        view.addSubview(addInstrumentBtn)
        
        configureCloseButtonConstraints()
        configureFiltersLabelConstraints()
        configureInstrumentsLabelConstraints()
        configureAddInstrumentButtonConstraints()
    }
    
    @objc func closeFilters()
    {
        delegate?.applyProfileFilters(filters: filters)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addInstrument()
    {
        let vc = SearchInstrumentPickerViewController()
        vc.delegate = self
        vc.instruments = self.instruments
        print("show picker")
        present(vc, animated: true, completion: nil)
    }
}

extension ProfileFiltersViewController : InstrumentsPickerDelegate
{
    func getPickedInstrument(instrument: String)
    {
        print("instrument to append: \(instrument)")
        filters.instruments?.append(instrument)
    }
}

extension ProfileFiltersViewController : FiltersViewDelegate
{
    func set(instruments: [String])
    {
        print("setInstrument from presenter \(instruments)")
        self.instruments = instruments
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
}
