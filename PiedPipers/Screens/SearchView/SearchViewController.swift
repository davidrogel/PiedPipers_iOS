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
    private let topView = TopSearchBarView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(topView)
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        
        
    }
}


class TopSearchBarView: UIView
{
    private let segmentedView:UISegmentedControl = {
        return UISegmentedControl(items: ["Users", "Locals"])
    }()
    
    private let filtersBtn:UIButton = {
        let btn = UIButton()
        btn.titleLabel?.text = "Filter"
        return btn
    }()
    
    private let searchBar:UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Busqueda"
        sb.searchBarStyle = .minimal
        return sb
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        addSubview(searchBar)
        
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
    
    fileprivate func configureSearchBarConstraints()
    {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        searchBar.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        
//        searchBar.topAnchor.constraint(equalTo: self.topAnchor, constant: 24).isActive = true
//        searchBar.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    }
}
