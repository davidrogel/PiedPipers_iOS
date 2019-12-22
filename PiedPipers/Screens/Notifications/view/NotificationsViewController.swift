//
//  NotificationsViewController.swift
//  PiedPipers
//
//  Created by Jon Gonzalez on 11/12/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit

enum NotisState {
    case empty
    case error
    case success
    case loading
}

class NotificationsViewController: UIViewController {
    
    // MARK: Properties
    var model: [NotificationCellPresentable] = []
    var state: NotisState! {
        didSet {
            switch state {
            case .empty:
                infoView.isHidden = false
                stateView.isHidden = false
                stateImage.image = UIImage(systemName: "info.circle.fill")
                stateImage.tintColor = UIColor.systemGray
                stateLabel.text = "You don't have any notification right now"
            case .error:
                infoView.isHidden = false
                stateView.isHidden = false
                stateImage.image = UIImage(systemName: "xmark.circle.fill")
                stateImage.tintColor = UIColor.systemRed
                stateLabel.text = "there was a problem loading your notifications"
            case .success:
                stateView.isHidden = true
            case .loading:
                stateView.isHidden = false
                infoView.isHidden = true
            case .none:
                stateView.isHidden = true
            }
        }
    }
    
    // MARK: Presenter elements
    public private(set) var presenter: NotificationsPresenterProtocol!
    
    func configure(with presenter: NotificationsPresenterProtocol) {
        self.presenter = presenter
    }

    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let nib = UINib(nibName: NotificationsTableViewCell.nibName, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: NotificationsTableViewCell.defaultReuseableId)
        }
    }
    @IBOutlet weak var stateView: UIView!
    @IBOutlet weak var stateImage: UIImageView!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        state = .loading
        presenter.getNotificationsList()
    }
    
    // MARK: Actions
    @IBAction func reloadButtonTapped(_ sender: Any) {
        presenter.getNotificationsList()
        state = .loading
    }
    
}

extension NotificationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCuid = model[indexPath.item].userCuid
        let vc = Assembler.provideUserProfile(with: selectedCuid, status: .other)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

extension NotificationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationsTableViewCell.defaultReuseableId, for: indexPath) as? NotificationsTableViewCell else {
            fatalError()
        }
        let notification = model[indexPath.item]
        cell.model = notification
        
        return cell
    }
}

extension NotificationsViewController: NotificationsViewProtocol {
    
    func showNotificationStateView(with state: NotisState) {
        self.state = state
    }
    func setNotifications(with notifications: [NotificationCellPresentable]) {
        state = .success
        model = notifications
        tableView.reloadData()
    }


}
