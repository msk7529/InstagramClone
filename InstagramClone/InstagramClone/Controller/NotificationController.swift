//
//  NotificationController.swift
//  InstagramClone
//
//  Created by kakao on 2021/04/04.
//

import UIKit

final class NotificationController: UITableViewController {
    // MARK: - Properties
    
    private var notifications: [Notification] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTalbeView()
        self.fetchNotifications()
    }
    
    // MARK: - Helpers
    private func fetchNotifications() {
        NotificationService.fetchNotification { notifications in
            self.notifications = notifications
        }
    }
    
    // MARK: - Helpers
    
    private func configureTalbeView() {
        view.backgroundColor = .clear
        navigationItem.title = "Notifications"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.identifier)
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
    }

    // MARK: - Actions
}

extension NotificationController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.identifier, for: indexPath) as? NotificationCell else {
            return UITableViewCell()
        }
        
        return cell
    }
}
