//
//  NotificationsTableViewCell.swift
//  PiedPipers
//
//  Created by Jon Gonzalez on 11/12/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit
import Kingfisher

class NotificationsTableViewCell: UITableViewCell {
    
    static let nibName: String = String(describing: NotificationsTableViewCell.self)
    static let defaultReuseableId: String = String(describing: NotificationsTableViewCell.self)
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var notificationLabel: UILabel!
    
    // MARK: Properties
    var model: NotificationCellPresentable! {
        didSet {
            let url = String.createUrl(fromImgPath: model.image)
            let placeholder = UIImage(named: "UserIcon")
            avatarImage.kf.setImage(with: url, placeholder: placeholder)
            putAttributedTextin(label: notificationLabel, withuser: model.userName)
            if model.notiState == .redeemed {
                acceptButton.setTitle("Accepted", for: .normal)
                acceptButton.isEnabled = false
            } else {
                acceptButton.setTitle("Accept", for: .normal)
            }
        }
    }
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        acceptButton.putShadowsAndRadiusWith(shadowColor: UIColor.clear.cgColor, shadowOffsetWidth: 0, shadowOffsetHeight: 0, shadowOpacity: 0, shadowRadius: 0, cornerRadius: 8)
        
        avatarImage.layer.cornerRadius = 8
        avatarImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        contentView.backgroundColor = .systemBackground
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
    }
    
    // MARK: Functions
    func putAttributedTextin(label: UILabel, withuser name: String) {
        let boldText = name
        let attrs = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
        let attributedString = NSMutableAttributedString(string: boldText, attributes: attrs)

        let normalText = " wants join to your band!"
        let normalString = NSMutableAttributedString(string:normalText)

        attributedString.append(normalString)
        
        label.attributedText = attributedString
    }
    
    // MARK: Actions
    @IBAction func acceptButtonTapped(_ sender: Any) {
        let repository = Repository.remote
        let currentUserCuid = StoreManager.shared.getLoggedUser()
        repository.redeemNotification(currentUserCUID: currentUserCuid, notificationCUID: model.cuid, success: { [weak self] (noti) in
            self?.acceptButton.setTitle("Accepted", for: .normal)
            self?.acceptButton.isEnabled = false
        }, failure: { [weak self] (error) in
            self?.acceptButton.backgroundColor = UIColor.red
            let _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
                self?.acceptButton.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
            }
        })
    }
}
