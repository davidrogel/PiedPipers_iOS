//
//  SearchInstrumentPickerViewController.swift
//  PiedPipers
//
//  Created by david rogel pernas on 14/12/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit

protocol InstrumentsPickerDelegate
{
    func getPickedInstrument(instrument: String)
}

class SearchInstrumentPickerViewController: UIViewController
{
    private let picker:UIPickerView = {
        let p = UIPickerView()
        p.translatesAutoresizingMaskIntoConstraints = false
        return p
    }()
    
    public var delegate: InstrumentsPickerDelegate?
    
    public var instruments:[String] = []
    {
        didSet
        {
            picker.reloadAllComponents()
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        picker.dataSource = self
        picker.delegate = self
        
        view.addSubview(picker)
        
        picker.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        picker.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        
        
//        picker.reloadAllComponents()
        // configurar constraints y demas
    }
}

extension SearchInstrumentPickerViewController : UIPickerViewDataSource, UIPickerViewDelegate
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return instruments.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        delegate?.getPickedInstrument(instrument: instruments[row])
        dismiss(animated: true, completion: nil)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return instruments[row]
    }
}
