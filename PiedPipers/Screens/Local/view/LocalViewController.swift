//
//  LocalViewController.swift
//  PiedPipers
//
//  Created by Jon Gonzalez on 15/12/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocalViewController: UIViewController {

    // MARK: Properties
    var images: [String] = []
    var localCuid: String!
    
    // MARK: Presenter elements
    public private(set) var presenter: LocalPreseterProtocol!
    
    func configure(with presenter: LocalPreseterProtocol, local: String) {
        self.presenter = presenter
        self.localCuid = local
    }
    
    // MARK: Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationPriceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var imageCollection: UICollectionView! {
        didSet {
            let nib = UINib(nibName: ImagesCollectionViewCell.nibName, bundle: nil)
            imageCollection.register(nib, forCellWithReuseIdentifier: ImagesCollectionViewCell.reusableId)
        }
    }
    @IBOutlet weak var callButton: UIButton!
    
    @IBOutlet weak var aboutViewHeight: NSLayoutConstraint!
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        callButton.putShadowsAndRadiusWith(shadowColor: UIColor.black.cgColor, shadowOffsetWidth: 0, shadowOffsetHeight: 1, shadowOpacity: 0.3, shadowRadius: 4, cornerRadius: 20)
        imageCollection.delegate = self
        imageCollection.dataSource = self
        imagesCollectionSetUpUI(height: 312, width: 312)
        presenter.getLocal(with: localCuid)
    }
    
    // MARK: Actions
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Functions
    func imagesCollectionSetUpUI(height: CGFloat, width: CGFloat) {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: width, height: height)
        collectionViewLayout.scrollDirection = .horizontal
        imageCollection.collectionViewLayout = collectionViewLayout
    }
    
    func setUpMapViewWith(lat: Double, long: Double, pointName: String) {
        let coords = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let point = MKPointAnnotation()
        point.coordinate = coords
        point.title = pointName
        let span = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
        let region = MKCoordinateRegion(center: coords, span: span)
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(point)
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
    }
    
    func lookUpLocation(with location: CLLocation, completionHandler: @escaping (CLPlacemark?)
                       -> Void ) {
           let geocoder = CLGeocoder()
           
           // Look up the location and pass it to the completion handler
           geocoder.reverseGeocodeLocation(location, completionHandler: {
                (placemarks, error) in
                   if error == nil {
                       let firstLocation = placemarks?[0]
                       completionHandler(firstLocation)
                   }
                   else {
                       // An error occurred during geocoding.
                       completionHandler(nil)
                   }
           })
       }
    
}

extension LocalViewController: LocalViewProtocol {
    
    func loadLocalData(with local: LocalPresentable) {
        let location = CLLocation(latitude: local.location.lat, longitude: local.location.long)
        lookUpLocation(with: location, completionHandler: { [weak self] (placemark) in
            self?.nameLabel.text = local.name
            guard let friendlyLocation = placemark?.locality else {
                fatalError()
            }
            self?.locationPriceLabel.text = "\(friendlyLocation) - \(local.price.toCurrency()) /h"
            self?.setUpMapViewWith(lat: local.location.lat, long: local.location.long, pointName: local.name)
            self?.descriptionText.text = local.description
            guard let height = self?.descriptionText.calculeDescriptionViewHeight(leading: 20, trailing: 20) else {
                fatalError()
            }
            self?.aboutViewHeight.constant = height
            self?.images = local.photos
            self?.imageCollection.reloadData()
        })
        
    }
}

extension LocalViewController: UICollectionViewDelegate {
    
}

extension LocalViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagesCollectionViewCell.reusableId, for: indexPath) as? ImagesCollectionViewCell else {
            fatalError()
        }
        
        cell.image = images[indexPath.item]
        
        return cell
    }
    
    
}
