//
//  instrumentsPickerViewController.swift
//  PiedPipers
//
//  Created by Jon Gonzalez on 04/12/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit

class InstrumentsPickerViewController: UIViewController {
    
    // MARK: Properties
    let instruments: [String]
    weak var delegate: InstrumentsPickerViewDelegate?
    
    // MARK: Initialization
    init(with instruments: [String]) {
        self.instruments = instruments
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Outlets
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var instrumentsPicker: UIPickerView!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolbar.barStyle = .black
        let cancelAction = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let addAction = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addInstrument))
        toolbar.items = [cancelAction, flexible, addAction]

        instrumentsPicker.delegate = self
        instrumentsPicker.dataSource = self
    }
    
    // MARK: Functions
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addInstrument() {
        let selectedInstrument = instruments[instrumentsPicker.selectedRow(inComponent: 0)]
        delegate?.addSelectedInstrument(withName: selectedInstrument)
        self.dismiss(animated: true, completion: nil)
    }

}

extension InstrumentsPickerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //TODO
    }
}

extension InstrumentsPickerViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return instruments.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return instruments[row]
    }
    
}

protocol InstrumentsPickerViewDelegate: class {
    //TODO
    //func takeAvailableInstruments() -> [String]
    func addSelectedInstrument(withName instrument: String)
}
