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
    
    // MARK: - Parameters
    
    var delegate:ProfileFiltersProtocol? = nil
    
    private var filters:SearchProfileParameters = SearchProfileParameters()
    
    // MARK: - Functions
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(closeBtn)
        view.addSubview(filtersLbl)
        view.addSubview(instrumentsLbl)
        
        configureCloseButtonConstraints()
        configureFiltersLabelConstraints()
        configureInstrumentsLabelConstraints()
    }
    
    @objc func closeFilters()
    {
        delegate?.applyProfileFilters(filters: filters)
        dismiss(animated: true, completion: nil)
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
        instrumentsLbl.topAnchor.constraint(equalTo: closeBtn.bottomAnchor, constant: 24).isActive = true
        instrumentsLbl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24).isActive = true
        instrumentsLbl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
    }
}
