//
//  LocalFiltersViewController.swift
//  PiedPipers
//
//  Created by david rogel pernas on 22/12/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit

protocol LocalFiltersProtocol
{
    func applyLocalFilters(filters: SearchLocalParameters)
}

final class LocalFiltersViewController : UIViewController
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
    
    private let priceLabel:UILabel = {
        let lbl = UILabel()
        lbl.text = "Price"
        lbl.font = UIFont.boldSystemFont(ofSize: 24)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let moneySlider:UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private let priceEditText:UITextField = {
        let et = UITextField()
        et.textAlignment = .right
        et.font = UIFont.boldSystemFont(ofSize: 22)
        et.placeholder = (00.00).toCurrency()
        et.translatesAutoresizingMaskIntoConstraints = false
        et.keyboardType = .numbersAndPunctuation
        et.returnKeyType = .done
        return et
    }()
    
    // MARK: - Parameters
    
    var delegate:LocalFiltersProtocol? = nil
    
    private var filters:SearchLocalParameters = SearchLocalParameters()
    
    // MARK: - Functions
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configure()
    }
    
    private func configure()
    {
        priceEditText.delegate = self
        
        view.addSubview(closeBtn)
        view.addSubview(filtersLbl)
        view.addSubview(priceLabel)
        view.addSubview(priceEditText)
        
        configureCloseButtonConstraints()
        configureFiltersLabelConstraints()
        configurePriceLabelConstraints()
        configurePriceEditTextConstraints()
    }
    
    @objc func closeFilters()
    {
        delegate?.applyLocalFilters(filters: filters)
        dismiss(animated: true, completion: nil)
    }
    
    public func setFilters(filters: SearchLocalParameters)
    {
        priceEditText.text = filters.price?.description
        self.filters = filters
    }
}

// MARK: - Constraints
extension LocalFiltersViewController
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
    
    private func configurePriceLabelConstraints()
    {
        priceLabel.topAnchor.constraint(equalTo: closeBtn.bottomAnchor, constant: 32).isActive = true
        priceLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24).isActive = true
    }
    
    private func configurePriceEditTextConstraints()
    {
        priceEditText.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor, constant: 2).isActive = true
        priceEditText.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 16).isActive = true
    }
}

extension LocalFiltersViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        guard let someText = textField.text else { return false }
        
        filters.price = Double(someText)
        
        textField.resignFirstResponder()
        
        return true
    }
}
