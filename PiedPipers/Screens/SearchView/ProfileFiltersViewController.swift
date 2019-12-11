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
    let closeBtn:UIButton = {
        let btn = FilterButton(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        btn.addImage(image: #imageLiteral(resourceName: "Close"))
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(closeFilters), for: .touchUpInside)
        return btn
    }()
    
    let filtersLbl:UILabel = {
        let lbl = UILabel()
        lbl.text = "Filters"
        lbl.font = UIFont.boldSystemFont(ofSize: 24)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    var delegate:ProfileFiltersProtocol? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(closeBtn)
        view.addSubview(filtersLbl)
        
        closeBtn.heightAnchor.constraint(equalToConstant: 48).isActive = true
        closeBtn.widthAnchor.constraint(equalTo: closeBtn.heightAnchor, multiplier: 1).isActive = true
        closeBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        closeBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        closeBtn.leadingAnchor.constraint(equalTo: filtersLbl.trailingAnchor, constant: 16).isActive = true
        
        filtersLbl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        filtersLbl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24).isActive = true
        filtersLbl.trailingAnchor.constraint(equalTo: closeBtn.leadingAnchor, constant: -16).isActive = true
        filtersLbl.centerYAnchor.constraint(equalTo: closeBtn.centerYAnchor).isActive = true
    }
    
    
    
    @objc func closeFilters()
    {
        dismiss(animated: true, completion: nil)
    }
}
