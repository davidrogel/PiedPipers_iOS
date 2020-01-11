//
//  ProfileViewController.swift
//  PiedPipers
//
//  Created by Jon Gonzalez on 10/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit
import Kingfisher

enum ProfileState {
    case loading
    case error
    case success
}

class ProfileViewController: UIViewController {
    
    // MARK: Properties
    var userCuid: String = ""
    var userInstruments: [String] = []
    var userVideos: [VideoPresentable] = []
    var selectedInstruments: [Bool] = []
    var selectedVideos: [Bool] = []
    var availableInstruments: [String] = []
    var reloadFromCamera: Bool = false
    var firstTimeEditing: Bool = false
    var isFollowing: Bool = false
    
    var profile: ProfilePresentable! {
        didSet {
            nameLabel.isHidden = false
            nameLabel.borderStyle = .none
            nameLabel.isEnabled = false
            nameLabel.text = profile.name
            if (profile.city == nil || profile.city == "") {
                friendlyLocationView.isHidden = true
            } else {
                friendlyLocationView.isHidden = false
                friendlyLocationLabel.borderStyle = .none
                friendlyLocationLabel.isEnabled = false
                friendlyLocationLabel.text = profile.city
            }
            editButton.isHidden = false

            avatarView.isHidden = false
            addPhotoButton.isHidden = true
            avatarImage.alpha = 1
            
            if let image = profile.avatar  {
                guard let url = String.createUrl(fromImgPath: image) else {
                    fatalError()
                }
                avatarImage.kf.setImage(with: url)
            }
            
            contactView.isHidden = true
            if profile.contact != nil {
                guard let type = profile.contact?.type else {
                    return
                }
                if type == .email {
                    contactType.selectedSegmentIndex = 0
                    contactButton.setImage(UIImage(named: "mailConnect"), for: .normal)
                } else {
                    contactType.selectedSegmentIndex = 1
                    contactButton.setImage(UIImage(named: "phoneConnect"), for: .normal)
                }
                contactText.text = profile.contact?.data
            }
            
            
            instrumentView.isHidden = false
            selectedInstruments = []
            userInstruments = profile.instruments ?? []
            userInstruments.forEach { _ in
                selectedInstruments.append(false)
            }
            calculateInstrumentsViewHeight()
            selectedVideos = []
            userVideos = profile.videos ?? []
            userVideos.forEach { _ in
                selectedVideos.append(false)
            }
            videoCollection.reloadData()
            if userVideos.isEmpty {
                videoView.isHidden = true
            } else {
                videoView.isHidden = false
            }
            
            
            if (profile.aboutMe == nil || profile.aboutMe == "") {
                aboutMeView.isHidden = true
            } else {
                aboutMeView.isHidden = false
                aboutMeText.isEditable = false
                aboutMeText.text = profile.aboutMe
            }
            aboutMeText.layer.borderWidth = 0
            aboutMeText.isScrollEnabled = false
            let height = calculeAboutMeHeight(textView: aboutMeText)
            aboutMeHeight.constant = height
            acceptView.isHidden = true
            
            state = .success
        }
    }
    
    var state: ProfileState! {
        didSet {
            switch state {
            case .loading:
                stateView.isHidden = false
                infoView.isHidden = true
            case .error:
                stateLabel.text = "There was a problem loading the profile"
                infoView.isHidden = false
                stateView.isHidden = false
            case .success:
                stateView.isHidden = true
            case .none:
                stateView.isHidden = true
            }
        }
    }
    
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
    @IBOutlet weak var addPhotoButton: UIButton!
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
    @IBOutlet weak var videoCollection: UICollectionView! {
        didSet {
            let nib = UINib(nibName: VideoCollectionViewCell.nibName, bundle: nil)
            videoCollection.register(nib, forCellWithReuseIdentifier: VideoCollectionViewCell.reusableId)
        }
    }
    @IBOutlet weak var aboutMeView: UIView!
    @IBOutlet weak var aboutMeText: UITextView!
    @IBOutlet weak var acceptView: UIView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var closeCancelView: UIView!
    @IBOutlet weak var closeCancelButton: UIButton!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var stateView: UIView!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    
    
    @IBOutlet weak var aboutMeHeight: NSLayoutConstraint!
    @IBOutlet weak var instrumentHorizontalSpacing: NSLayoutConstraint!
    @IBOutlet weak var instrumentsViewHeight: NSLayoutConstraint!
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtons()
        configureImage()
        instrumentsCollectionSetUpUI(withItemHeight: 34)
        instrumentCollection.reloadData()
        videosCollectionSetUpUI(height: 180, width: 319)
        videoCollection.reloadData()
        addPhotoButton.layer.cornerRadius = 20
        
        instrumentCollection.delegate = self
        instrumentCollection.dataSource = self
        
        videoCollection.delegate = self
        videoCollection.dataSource = self
        contactText.autocapitalizationType = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        switch presenter.profileMode {
        case .current:
            presenter.loadUserProfile()
            state = .loading
        case .editing:
            setEditProfileView()
        case .other:
            presenter.loadSelectedUserProfile(with: userCuid)
            state = .loading
        }
        
    }
    
    // MARK: Actions
    @IBAction func reloadButtonTapped(_ sender: Any) {
        if presenter.profileMode == .current {
            presenter.loadUserProfile()
        }
        if presenter.profileMode == .other {
            presenter.loadSelectedUserProfile(with: userCuid)
        }
    }
    @IBAction func editExitButtonTapped(_ sender: Any) {
        if presenter.profileMode == .current {
            presenter.prepareEditView()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func contactTypeChanged(_ sender: Any) {
        switch contactType.selectedSegmentIndex {
        case 0:
            contactText.keyboardType = .emailAddress
            contactText.textContentType = .emailAddress
            contactText.placeholder = "user@domain.com"
        case 1:
            contactText.keyboardType = .phonePad
            contactText.textContentType = .telephoneNumber
            contactText.placeholder = "+34 672938094"
        default:
            contactText.keyboardType = .emailAddress
            contactText.textContentType = .emailAddress
        }
        contactText.text = ""
    }
    
    @IBAction func followButtonTapped(_ sender: Any) {
        if !isFollowing {
            presenter.followUser(with: userCuid)
        } else {
            presenter.unFollowUser(with: userCuid)
        }
        
    }
    
    @IBAction func closeCancelButtonTapped(_ sender: Any) {
        if presenter.profileMode == .editing && !firstTimeEditing {
            presenter.profileMode = .current
            presenter.loadUserProfile()
            state = .loading
        } else {
            let cuid = StoreManager.shared.getLoggedUser()
            let tokenDeleted = StoreManager.shared.deleteData(withKey: cuid)
            if tokenDeleted {
                StoreManager.shared.removeStoreCuid()
                self.dismiss(animated: true, completion: nil)
            } else {
                let alert = createAlert(withTitle: "Error logging out.", message: "There was an error logging out. Please retry in a few minutes.")
                self.present(alert, animated: true)
            }
            
        }
    }
    
    @IBAction func acceptButtonTapped(_ sender: Any) {
        let name = nameLabel.text
        if name == "" {
            self.present(createAlert(withTitle: "Name cannot be empty", message: "Insert your name in the name field."), animated: true)
            return
        }
        let instrument = selectedInstruments.first { $0 == false}
        if instrument == nil {
            self.present(createAlert(withTitle: "Instrument cannot be empty", message: "Select at least one instrument."), animated: true)
            return
        }
        
        if contactText.text == "" {
            self.present(createAlert(withTitle: "Contact cannot be empty", message: "Insert your contact data."), animated: true)
            return
        }
        guard let contactData = contactText.text else {
            return
        }
        let typeContact: TypePresentable
        if contactType.selectedSegmentIndex == 0 {
            typeContact = TypePresentable.email
            if !contactData.isValidEmail() {
                self.present(createAlert(withTitle: "The inserted text isn't an email", message: "Insert a valid email."), animated: true)
                return
            }
        } else {
            typeContact = TypePresentable.phone
            if !contactData.isValidPhone() {
                self.present(createAlert(withTitle: "The inserted text isn't a phone", message: "Insert a valid phone."), animated: true)
                return
            }
        }
        
        guard let img = avatarImage.image else {
            self.present(createAlert(withTitle: "Profile image not found", message: "You have to insert profile image."), animated: true)
            return
        }
        
        var updateInstruments: [String] = []
        for n in 0...selectedInstruments.count - 1 {
            if selectedInstruments[n] == false {
                updateInstruments.append(userInstruments[n])
            }
        }
        
        var updateVideos: [VideoPresentable] = []
        if selectedVideos.count > 0 {
            for n in 0...selectedVideos.count - 1 {
                if selectedVideos[n] == false {
                    updateVideos.append(userVideos[n+1])
                }
            }
        }
        
        
        let contact = ContactPresentable(type: typeContact, data: contactData)
        
        let resizedImage = img.resize(size: CGSize(width: 300, height: 300))
        guard let data = resizedImage?.jpegData(compressionQuality: 1) else {
            fatalError()
        }
        
        let city: String?
        if friendlyLocationLabel.text == "" {
            city = nil
        } else {
            city = friendlyLocationLabel.text
        }
        
        let aboutMe: String?
        if aboutMeText.text == "" {
            aboutMe = nil
        } else {
            aboutMe = aboutMeText.text
        }
        
        let newProfile = ProfilePresentable(name: name, city: city, avatar: nil, location: nil, contact: contact, instruments: updateInstruments, videos: updateVideos, aboutMe: aboutMe)

        state = .loading
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
        presenter.updateProfile(with: newProfile, image: data)
        
        
    }
    
    @IBAction func addPhotoTapped(_ sender: Any) {
        
        ImagePickerManager().pickImage(self) { (image) in
            self.avatarImage.image = image
        }
    }
    
    // MARK: Functions
    func createAlert(withTitle title: String?, message: String?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: nil))
        return alert
    }
    
    func videosCollectionSetUpUI(height: CGFloat, width: CGFloat) {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: width, height: height)
        collectionViewLayout.scrollDirection = .horizontal
        videoCollection.collectionViewLayout = collectionViewLayout
    }
    
    func instrumentsCollectionSetUpUI(withItemHeight itemHeight: CGFloat) {
        let width = calculateCollectionItemWidth(columnCount: 3, itemSpacing: 10)
        let collectionViewLayout = UICollectionViewFlowLayout()
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
        avatarView.layer.shadowColor = UIColor.systemGray.cgColor
        avatarView.layer.shadowOffset = .zero
        avatarView.layer.shadowOpacity = 0.8
        avatarView.layer.shadowRadius = 10
        avatarView.layer.cornerRadius = 20
        avatarView.layer.rasterizationScale = UIScreen.main.scale
        avatarView.layer.borderWidth = 0
        
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
        var height = CGFloat(75)
        if (rows > 1) {
            let additionalHeight: CGFloat = 45
            height += (additionalHeight * (rows - 1))
        }
        return height
    }
    
    fileprivate func calculateInstrumentsViewHeight() {
        let items: Double = Double(userInstruments.count)
        let rows = CGFloat((items / 3.0).rounded(.up))
        instrumentsViewHeight.constant = calculateInstrumentCollectionHeight(withRows: rows)
        instrumentCollection.reloadData()
    }
    
    func following() {
        followButton.backgroundColor = UIColor.systemGray3
        followButton.setTitleColor(UIColor.systemGray6, for: .normal)
        followButton.setTitle("Unfollow", for: .normal)
        followButton.isEnabled = true
    }

}

// MARK: Extension
extension ProfileViewController: ProfileViewProtocol {
    
    func setCurrentUserProfileViewWith(model: ProfilePresentable) {
        presenter.profileMode = .current
        profile = model
        editButton.setImage(UIImage(named: "editButton"), for: .normal)
        followView.isHidden = true
        closeCancelView.isHidden = false
        closeCancelButton.setTitle("Close session", for: .normal)
        contactButton.isHidden = true
    }
    
    func setEditProfileView() {
        presenter.profileMode = .editing
        presenter.getAvailableInstruments()
        
        nameLabel.borderStyle = .roundedRect
        nameLabel.isEnabled = true
        friendlyLocationView.isHidden = false
        friendlyLocationLabel.borderStyle = .roundedRect
        friendlyLocationLabel.isEnabled = true
        editButton.isHidden = true
        addPhotoButton.isHidden = false
        avatarImage.alpha = 0.5
        followView.isHidden = true
        contactView.isHidden = false
        if selectedInstruments.count != userInstruments.count - 1 {
            userInstruments.append("Add")
        }
        calculateInstrumentsViewHeight()
        videoView.isHidden = false
        if selectedVideos.count != userVideos.count - 1 {
            userVideos.insert(VideoPresentable(id: "Add", videoURL: "Add", thumbnail: "Add"), at: 0)
        }
        videoCollection.reloadData()
        aboutMeView.isHidden = false
        aboutMeText.isEditable = true
        aboutMeText.layer.borderWidth = 1
        aboutMeText.layer.borderColor = UIColor.systemGray5.cgColor
        aboutMeText.isScrollEnabled = true
        aboutMeHeight.constant = 300
        acceptView.isHidden = false
        closeCancelButton.setTitle("Cancel", for: .normal)
        contactButton.isHidden = true
        state = .success
        let cuid = StoreManager.shared.getLoggedUser()
        let hasData = StoreManager.shared.getMinimumDataIsInserted(for: cuid)
        if !hasData {
            firstTimeEditing = true
        }
    }
    func setOtherUserProfileWith(model: ProfilePresentable, invitations: [String], followers: [String]) {
        profile = model
        editButton.setImage(UIImage(named: "exitButton"), for: .normal)
        followView.isHidden = false
        closeCancelView.isHidden = true
        contactButton.isHidden = false
        invitations.forEach { invitation in
            if invitation == userCuid {
                wantToFollow()
            }
        }
        followers.forEach { follower in
            if follower == userCuid {
                following()
                isFollowing = true
            }
        }
        state = .success
    }
    
    func setAvailableInstruments(with instruments: [String]) {
        availableInstruments = instruments
    }
    
    func showUpdateAlert(successfully: Bool) {
        if successfully {
            if firstTimeEditing {
                let cuid = StoreManager.shared.getLoggedUser()
                StoreManager.shared.setMinimumDataIsInserted(for: cuid, with: true)
                let alert = UIAlertController(title: "Success updating.", message: "Your profile has updated successfully.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true)
            } else {
                self.present(createAlert(withTitle: "Success updating.", message: "Your profile has updated successfully."), animated: true)
                self.presenter.loadUserProfile()
            }
        } else {
            self.present(createAlert(withTitle: "Error updating.", message: "There was an error updating the profile."), animated: true)
            state = .success
        }
    }
    
    func wantToFollow() {
        followButton.backgroundColor = UIColor.systemGray3
        followButton.setTitleColor(UIColor.systemGray6, for: .normal)
        followButton.setTitle("Pending to accept", for: .normal)
        followButton.isEnabled = false
    }
    
    func dontFollow() {
        followButton.backgroundColor = UIColor(red:0.93, green:0.41, blue:0.41, alpha:1.0)
        followButton.setTitle("Follow", for: .normal)
        followButton.setTitleColor(UIColor.white, for: .normal)
        followButton.isEnabled = true
        isFollowing = false
    }
    
    func showErrorView() {
        state = .error
    }
    
    func showFollowUnfollowError() {
        let alert = createAlert(withTitle: "There was an error", message: "An error occurred while performing the operation.")
        self.present(alert, animated: true)
    }
}

extension ProfileViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (presenter.profileMode == .editing) {
            if collectionView == self.instrumentCollection {
                let cell = collectionView.cellForItem(at: indexPath) as! InstrumentCollectionViewCell
                if userInstruments[indexPath.item] == "Add" {
                    let instrumentsPickerView = InstrumentsPickerViewController(with: availableInstruments)
                    instrumentsPickerView.delegate = self
                    self.present(instrumentsPickerView, animated: true)
                } else {
                    if selectedInstruments[indexPath.item] {
                        cell.deselectCell()
                        selectedInstruments[indexPath.item] = false
                    } else {
                        cell.selectedToRemove()
                        selectedInstruments[indexPath.item] = true
                    }
                }
            } else {
                let cell = collectionView.cellForItem(at: indexPath) as! VideoCollectionViewCell
                if userVideos[indexPath.item].thumbnail == "Add" {
                    let alert = UIAlertController(title: "Insert a valid YouTube URL", message: nil, preferredStyle: .alert)
                    alert.addTextField { (textField) in
                        textField.placeholder = "https://www.youtube.com/watch?v=dzWBgb9cr1s"
                    }
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: { [weak alert, weak self] (_) in
                        guard let text = alert?.textFields![0].text else {
                            fatalError()
                        }
                        // Puedo llamar a una función que reciba el texto
                        if !text.isValidYoutubeUrl() {
                            let youtubeAlert = UIAlertController(title: "It is not a YouTube video URL", message: "The inserted text is not a YouTube video URL.", preferredStyle: .alert)
                            youtubeAlert.addAction(UIAlertAction(title: "Accept", style: .default, handler: nil))
                            self?.present(youtubeAlert, animated: true)
                            return
                        }
                        
                        guard let url = URL(string: text) else {
                            let invalidUrl = UIAlertController(title: "Invalid URL", message: "The inserted text is not a valid URL.", preferredStyle: .alert)
                            invalidUrl.addAction(UIAlertAction(title: "Accept", style: .default, handler: nil))
                            self?.present(invalidUrl, animated: true)
                            return
                        }
                        var videoId = ""
                        if let videoQuery = url.query {
                            let parameters = videoQuery.split(separator: "&")
                            parameters.forEach { parameter in
                                if parameter.contains("v=") {
                                    videoId = String(parameter)
                                    videoId.removeFirst(2)
                                }
                            }
                        } else {
                            videoId = url.path
                            videoId.removeFirst()
                        }
                        let thumbnail = "https://img.youtube.com/vi/" + videoId + "/hqdefault.jpg"
                        self?.userVideos.append(VideoPresentable(id: videoId, videoURL: text, thumbnail: thumbnail))
                        self?.selectedVideos.append(false)
                        self?.videoCollection.reloadData()
                    }))
                    self.present(alert, animated: true)
                } else {
                    if selectedVideos[indexPath.item - 1] {
                        cell.deselectCell()
                        selectedVideos[indexPath.item - 1] = false
                    } else {
                        cell.selectedToRemove()
                        selectedVideos[indexPath.item - 1] = true
                    }
                }
            }
        } else {
            if collectionView == self.videoCollection {
                let video = userVideos[indexPath.item]
                guard let videoURL = video.videoURL else {
                    fatalError()
                }
                guard let url = URL(string: videoURL) else {
                    fatalError()
                }
                UIApplication.shared.open(url)
            }
        }
    }
}

extension ProfileViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.instrumentCollection {
            return userInstruments.count
        } else {
            return userVideos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.instrumentCollection {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InstrumentCollectionViewCell.reusableId, for: indexPath) as? InstrumentCollectionViewCell else {
                fatalError()
            }
            let instrument = userInstruments[indexPath.item]
            
            cell.name = instrument
            if instrument == "Add" {
                cell.showAddCell()
            } else {
                if (presenter.profileMode == .editing) {
                    cell.showRemoveButton()
                    if selectedInstruments[indexPath.item] {
                        cell.selectedToRemove()
                    } else {
                        cell.deselectCell()
                    }
                } else {
                    cell.hideRemoveButton()
                    cell.deselectCell()
                }
            }
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionViewCell.reusableId, for: indexPath) as? VideoCollectionViewCell else {
                fatalError()
            }
            let video = userVideos[indexPath.item]
            
            if video.thumbnail == "Add" {
                cell.showAddCell()
            } else {
                cell.image = video.thumbnail
                if (presenter.profileMode == .editing
                    ) {
                    cell.showRemoveButton()
                    if selectedVideos[indexPath.item - 1] {
                        cell.selectedToRemove()
                    } else {
                        cell.deselectCell()
                    }
                } else {
                    cell.hideRemoveButton()
                    cell.deselectCell()
                }
            }
            
            return cell
        }
    }
}

extension ProfileViewController: InstrumentsPickerViewDelegate {
    func addSelectedInstrument(withName instrument: String) {
        let count = userInstruments.count
        userInstruments.remove(at: count - 1)
        userInstruments.append(instrument)
        selectedInstruments.append(false)
        userInstruments.append("Add")
        calculateInstrumentsViewHeight()
    }
}
