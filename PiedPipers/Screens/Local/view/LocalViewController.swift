//
//  LocalViewController.swift
//  PiedPipers
//
//  Created by Jon Gonzalez on 15/12/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit
import MapKit

class LocalViewController: UIViewController {

    // MARK: Properties
    var images: [String] = []
    
    // MARK: Presenter elements
    public private(set) var presenter: LocalPreseterProtocol!
    
    func configure(with presenter: LocalPreseterProtocol) {
        self.presenter = presenter
    }
    
    // MARK: Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationPriceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var imageCollection: UICollectionView!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        imageCollection.delegate = self
        imageCollection.dataSource = self
    }
    
    // MARK: Actions
    @IBAction func closeButtonTapped(_ sender: Any) {
    }
    
}

extension LocalViewController: LocalViewProtocol {
    
    func loadLocalData(with local: LocalPresentable) {
        //TODO
    }
}

extension LocalViewController: UICollectionViewDelegate {
    
}

extension LocalViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //TODO
        return UICollectionViewCell()
    }
    
    
}
