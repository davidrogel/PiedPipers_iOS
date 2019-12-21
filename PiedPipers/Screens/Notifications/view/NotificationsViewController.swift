//
//  NotificationsViewController.swift
//  PiedPipers
//
//  Created by Jon Gonzalez on 11/12/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController {
    
    // MARK: Properties
    var model: [NotificationCellPresentable] = []
    
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
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        presenter.getNotificationsList()
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
    func setNotifications(with notifications: [NotificationCellPresentable]) {
        model = notifications
        tableView.reloadData()
    }
    
    
}
