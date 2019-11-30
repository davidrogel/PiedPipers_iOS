//
//  SearchTextField.swift
//  PiedPipers
//
//  Created by david rogel pernas on 26/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit

class SearchTextField: UIView
{
    // MARK: - Views
    let inputTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Search..."
        tf.clearButtonMode = .whileEditing
        return tf
    }()
    
    // MARK: - Constructors
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
    
    // MARK: - Configuration
    
    override func layoutSubviews()
    {
        super.layoutSubviews()

        shadows()
        mainShape()
        textView()
    }
    
    private func shadows() {
        let shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 30)
        
        self.layer.shadowPath = shadowPath.cgPath
        self.layer.shadowColor = UIColor(red: 0.227, green: 0.227, blue: 0.227, alpha: 0.3).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.bounds = self.bounds
        self.layer.position = self.center
    }
    
    private func mainShape() {
        let shapes = UIView()
        shapes.backgroundColor = .white
        shapes.frame = self.frame
        //        shapes.clipsToBounds = true
        shapes.isUserInteractionEnabled = false
        
        self.addSubview(shapes)
        
        shapes.layer.cornerRadius = 30
        
        shapes.translatesAutoresizingMaskIntoConstraints = false
        
        shapes.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        shapes.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        shapes.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        shapes.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    private func textView() {
        self.addSubview(inputTextField)
        
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        
        inputTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        inputTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        inputTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        inputTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
    }
    
    private func setup()
    {
        keyboardConfiguration()
    }
    
    private func keyboardConfiguration()
    {
        inputTextField.keyboardType = .default
        inputTextField.returnKeyType = .search
//        textContentType = .name
        inputTextField.autocapitalizationType = .sentences
        inputTextField.autocorrectionType = .no
        inputTextField.enablesReturnKeyAutomatically = true
    }
}

