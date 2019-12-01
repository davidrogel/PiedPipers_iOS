//
//  ProfileViewController.swift
//  PiedPipers
//
//  Created by Jon Gonzalez on 10/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: Properties
    var instruments: [String] = []
    let collectionViewLayout = UICollectionViewFlowLayout()
    
    
    // MARK: Presenter elements
    public private(set) var presenter: ProfilePresenterProtocol!
    
    func configure(with presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var friendlyLocationLabel: UITextField!
    @IBOutlet weak var friendlyLocationView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var followView: UIView!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var contactType: UISegmentedControl!
    @IBOutlet weak var contactText: UITextField!
    @IBOutlet weak var instrumentView: UIView!
    @IBOutlet weak var instrumentCollection: UICollectionView! {
        didSet {
            let nib = UINib(nibName: InstrumentCollectionViewCell.nibName, bundle: nil)
            instrumentCollection.register(nib, forCellWithReuseIdentifier: InstrumentCollectionViewCell.reusableId)
        }
    }
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var videoCollection: UICollectionView!
    @IBOutlet weak var aboutMeView: UIView!
    @IBOutlet weak var aboutMeText: UITextView!
    @IBOutlet weak var acceptView: UIView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var closeCancelView: UIView!
    @IBOutlet weak var closeCancelButton: UIButton!
    @IBOutlet weak var contactButton: UIButton!
    
    @IBOutlet weak var aboutMeHeight: NSLayoutConstraint!
    @IBOutlet weak var instrumentHorizontalSpacing: NSLayoutConstraint!
    @IBOutlet weak var instrumentsViewHeight: NSLayoutConstraint!
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtons()
        configureImage()
        CollectionViewSetUpUI(withItemHeight: 34)
        instrumentCollection.reloadData()
        
        instrumentCollection.delegate = self as UICollectionViewDelegate
        instrumentCollection.dataSource = self as UICollectionViewDataSource
        
        presenter.loadCurrentUserProfile()
    }
    
    // MARK: Actions
    @IBAction func editExitButtonTapped(_ sender: Any) {
        presenter.prepareEditView()
    }
    
    @IBAction func contactTypeChanged(_ sender: Any) {
        switch contactType.selectedSegmentIndex {
        case 0:
            contactText.keyboardType = .emailAddress
            contactText.textContentType = .emailAddress
        case 1:
            contactText.keyboardType = .phonePad
            contactText.textContentType = .telephoneNumber
        default:
            contactText.keyboardType = .emailAddress
            contactText.textContentType = .emailAddress
        }
    }
    
    @IBAction func closeCancelButtonTapped(_ sender: Any) {
        if presenter.isEditing {
            presenter.isEditing.toggle()
            presenter.loadCurrentUserProfile()
        } else {
            StoreManager.shared.removeStoreCuid()
            tabBarController?.selectedIndex = 0
        }
    }
    
    @IBAction func acceptButtonTapped(_ sender: Any) {
        
    }
    
    // MARK: Functions
    func CollectionViewSetUpUI(withItemHeight itemHeight: CGFloat) {
        let width = calculateCollectionItemWidth(columnCount: 3, itemSpacing: 10)
        collectionViewLayout.itemSize = CGSize(width: width, height: itemHeight)
        instrumentCollection.collectionViewLayout = collectionViewLayout
        
    }
    
    func calculateCollectionItemWidth(columnCount: CGFloat, itemSpacing: CGFloat) -> CGFloat {
        let totalSpacing: CGFloat = (columnCount - 1) * itemSpacing
        let totalWidth: CGFloat = UIScreen.main.bounds.width - (instrumentHorizontalSpacing.constant * 2)
        
        return (totalWidth - totalSpacing) / columnCount
    }
    
    private func configureButtons() {
        let _ = [acceptButton, followButton, closeCancelButton].map { $0?.putShadowsAndRadiusWith(shadowColor: UIColor.black.cgColor, shadowOffsetWidth: 0, shadowOffsetHeight: 1, shadowOpacity: 0.3, shadowRadius: 4, cornerRadius: 20)}
    }
    
    private func configureImage() {
        avatarView.layer.shadowColor = UIColor.clear.cgColor
        avatarView.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        avatarView.layer.shadowOpacity = 1
        avatarView.layer.shadowRadius = 4.0
        
        avatarImage.layer.cornerRadius = 20
        avatarImage.layer.masksToBounds = true
    }
    
    fileprivate func calculeAboutMeHeight(textView: UITextView) -> CGFloat{
        let width = UIScreen.main.bounds.width - 40
        let newSize = textView.sizeThatFits(CGSize(width: width,
                                                   height: CGFloat.greatestFiniteMagnitude))
        return newSize.height + 50
    }
    
    fileprivate func calculateInstrumentCollectionHeight(withRows rows: CGFloat) -> CGFloat {
        var height = instrumentsViewHeight.constant
        if (rows > 1) {
            let additionalHeight: CGFloat = 45
            height += (additionalHeight * (rows - 1))
        }
        return height
    }

}

extension ProfileViewController: ProfileViewProtocol {
    
    func setCurrentUserProfileViewWith(model: ProfilePresentable) {
        
        nameLabel.isHidden = false
        nameLabel.borderStyle = .none
        nameLabel.isEnabled = false
        nameLabel.text = model.name
        
        if (model.city == nil || model.city == "") {
            friendlyLocationView.isHidden = true
        } else {
            friendlyLocationView.isHidden = false
            friendlyLocationLabel.borderStyle = .none
            friendlyLocationLabel.isEnabled = false
            friendlyLocationLabel.text = model.city
        }
        
        editButton.isHidden = false
        editButton.setImage(UIImage(named: "editButton"), for: .normal)
        
        avatarView.isHidden = false
        avatarImage.image = UIImage(named: "LogoSobreNegro") //TODO: Esto hay que quitarlo
        
        followView.isHidden = true
        contactView.isHidden = true
        
        guard let type = model.contact?.type else {
            return
        }
        if type == .email {
            contactType.selectedSegmentIndex = 0
        } else {
            contactType.selectedSegmentIndex = 1
        }
        contactText.text = model.contact?.data
        
        instrumentView.isHidden = false
        
        instruments = model.instruments ?? []
        let items: Double = Double(instruments.count)
        let rows = CGFloat((items / 3.0).rounded(.up))
        instrumentsViewHeight.constant = calculateInstrumentCollectionHeight(withRows: rows)
        instrumentCollection.reloadData()
        videoView.isHidden = false
        
        if (model.aboutMe == nil || model.aboutMe == "") {
            aboutMeView.isHidden = true
        } else {
            aboutMeView.isHidden = false
            aboutMeText.isEditable = false
            aboutMeText.text = model.aboutMe
        }
        
        acceptView.isHidden = true
        closeCancelView.isHidden = false
        closeCancelButton.setTitle("Close session", for: .normal)
        contactButton.isHidden = true
        
        let height = calculeAboutMeHeight(textView: aboutMeText)
        aboutMeHeight.constant = height

    }
    
    func setEditProfileView() {
        //TODO
        presenter.isEditing.toggle()
        
        nameLabel.borderStyle = .roundedRect
        nameLabel.isEnabled = true
        friendlyLocationView.isHidden = false
        friendlyLocationLabel.borderStyle = .roundedRect
        friendlyLocationLabel.isEnabled = true
        editButton.isHidden = true
        avatarImage.image = UIImage(named: "addImage")
        contactView.isHidden = false
        instrumentCollection.reloadData()
        videoView.isHidden = false
        aboutMeView.isHidden = false
        aboutMeText.isEditable = true
        acceptView.isHidden = false
        closeCancelButton.setTitle("Cancel", for: .normal)
        
    }
    
    func setOtherUserProfileWith(model: ProfilePresentable) {
        //TODO
    }
    
    
}

extension ProfileViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (presenter.isEditing) {
            let cell = collectionView.cellForItem(at: indexPath) as! InstrumentCollectionViewCell
            cell.selectedToRemove()
        }
    }
}

extension ProfileViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return instruments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InstrumentCollectionViewCell.reusableId, for: indexPath) as? InstrumentCollectionViewCell else {
            fatalError()
        }
        let instrument = instruments[indexPath.item]
        cell.name = instrument
        if (presenter.isEditing) {
            cell.showRemoveButton()
        } else {
            cell.hideRemoveButton()
        }
        
        return cell
    }
    
    
}
