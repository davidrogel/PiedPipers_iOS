//
//  TopView.swift
//  PiedPipers
//
//  Created by david rogel pernas on 28/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit

protocol TopViewDelegate: class
{
    func segmentedViewSegmentedIndexChanged(valueChanged value: Int)
    func searchBarSearchButtonPressed(valueToSearch value: String)
    func profileFiltesParametersChanged(params: SearchProfileParameters)
    func localFiltersParametersChanged(params: SearchLocalParameters)
}

class TopView: UIView
{
    // MARK: - Views & Controllers
    
    private let segmentedView:UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Users", "Locals"])
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleValueChange), for: .valueChanged)
        return sc
    }()

    private let filtersBtn:UIButton = {
        let fb = FilterButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60)) // frame: CGRect(x: 0, y: 0, width: 60, height: 60)
        fb.addTarget(self, action: #selector(filtersButtonPressed), for: .touchUpInside)
        return fb
    }()
    
//    private let searchBar:UISearchBar = {
//        let sb = UISearchBar(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
//        sb.placeholder = "Busqueda"
//        sb.searchBarStyle = .minimal
////        sb.setShowsCancelButton(true, animated: true)
////        sb.showsCancelButton = true
//        return sb
//    }()
    
    private let searchBar:SearchTextField = SearchTextField()
    
    // MARK: - Parameters
    
    weak var delegate:TopViewDelegate? = nil
    
    // MARK: - Constructors
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        setup()
    }
    
//    override func layoutSubviews()
//    {
//        super.layoutSubviews()
//
//    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
    
    // MARK: - Configuration
    
    private func setup()
    {
        searchBar.inputTextField.delegate = self
        
        self.addSubview(filtersBtn)
        self.addSubview(searchBar)
        self.addSubview(segmentedView)
        
        configureFiltersButtonConstraints()
        configureSearchBarConstraints()
        configureSegmentedViewConstraints()
    }
    
    private func configureFiltersButtonConstraints()
    {
        filtersBtn.translatesAutoresizingMaskIntoConstraints = false
        
        filtersBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        filtersBtn.widthAnchor.constraint(equalTo: filtersBtn.heightAnchor, multiplier: 1).isActive = true
        filtersBtn.topAnchor.constraint(equalTo: self.topAnchor,constant: 16).isActive = true
        filtersBtn.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        filtersBtn.trailingAnchor.constraint(equalTo: searchBar.leadingAnchor, constant: -16).isActive = true
    }
    
    private func configureSearchBarConstraints()
    {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.heightAnchor.constraint(equalTo: filtersBtn.heightAnchor).isActive = true
        
        searchBar.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: filtersBtn.trailingAnchor, constant: 16).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        
        segmentedView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureSegmentedViewConstraints()
    {
        segmentedView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16).isActive = true
        segmentedView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
        segmentedView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    // MARK: - Functions
    
    @objc private func handleValueChange()
    {
    #if DEBUG
        if delegate == nil { print("no hay delegado ") }
    #endif
        delegate?.segmentedViewSegmentedIndexChanged(valueChanged: segmentedView.selectedSegmentIndex)
    }
    
    @objc private func filtersButtonPressed()
    {
        // determinar que filtros hay que aplicar... locales? perfiles?
        // abrir sección
        print("filters button tapped")
    }
}

// MARK: - InputTextField Delegate
extension TopView: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        guard let someText = textField.text else { return false }
        print("el usuario se ha puesto a buscar la siguiente información:", someText)
        
        #if DEBUG
            if delegate == nil { print("no hay delegado ") }
        #endif
        delegate?.searchBarSearchButtonPressed(valueToSearch: someText)
        
        textField.resignFirstResponder()
        return true
    }
}

//extension TopSearchBarView: UISearchBarDelegate
//{
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
//    {
//        guard let someText = searchBar.text else { return }
//
//        searchBar.endEditing(true)
//        delegate?.searchBarInputChanged(value: someText)
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
//    {
//        searchBar.endEditing(true)
//    }
//}



//extension UIView
//{
//    @discardableResult
//    func corners(radius: CGFloat) -> UIView
//    {
//        self.layer.cornerRadius = radius
//        self.layer.masksToBounds = true
//        return self
//    }
//
//    @discardableResult
//    func shadow(radius: CGFloat, color: UIColor, offset: CGSize, opacity: Float) -> UIView
//    {
//        self.layer.shadowRadius = radius
//        self.layer.shadowColor = color.cgColor
//        self.layer.shadowOffset = offset
//        self.layer.opacity = opacity
//        return self
//    }
//}
