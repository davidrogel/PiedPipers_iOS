//
//  NotificationsTableViewCell.swift
//  PiedPipers
//
//  Created by Jon Gonzalez on 11/12/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {
    
   static let nibName: String = String(describing: NotificationsTableViewCell.self)
    static let defaultReuseableId: String = String(describing: NotificationsTableViewCell.self)
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var notificationLabel: UILabel!
    
    // MARK: Properties
    var model: NotificationCellPresentable! {
        didSet {
            avatarImage.image = UIImage(named: model.image)
            putAttributedTextin(label: notificationLabel, withuser: model.userName)
            if model.notificationAccepted {
                acceptButton.setTitle("Accepted", for: .normal)
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
}
