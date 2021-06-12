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
    
    private let refresher: UIRefreshControl = .init()
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTalbeView()
        self.fetchNotifications()
    }
    
    // MARK: - API
    private func fetchNotifications() {
        NotificationService.fetchNotification { notifications in
            self.notifications = notifications
            self.checkUserIfFollowed()
        }
    }
    
    private func checkUserIfFollowed() {
        self.notifications.forEach { notification in
            guard notification.type == .follow else { return }
            
            UserService.checkIfUserIsFollowed(uid: notification.uid) { isFollowed in
                if let index = self.notifications.firstIndex(where: { $0.id == notification.id }) {
                    self.notifications[index].userIsFollowd = isFollowed
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    private func configureTalbeView() {
        view.backgroundColor = .clear
        navigationItem.title = "Notifications"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.identifier)
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        
        self.refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = self.refresher
    }

    // MARK: - Actions
    @objc private func handleRefresh() {
        notifications.removeAll()
        fetchNotifications()
        refresher.endRefreshing()
    }
}

// MARK: - UITableViewDataSource

extension NotificationController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.identifier, for: indexPath) as? NotificationCell else {
            return UITableViewCell()
        }
        
        cell.viewModel = NotificationViewModel(notification: notifications[indexPath.row])
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate

extension NotificationController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showLoader(true)
        
        let uid: String = notifications[indexPath.row].uid
        
        UserService.fetchUser(withUid: uid) { user in
            DispatchQueue.main.async {
                self.showLoader(false)
            }
            let profileVC: ProfileController = .init(user: user)
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
}

// MARK: - NotificationCellDelegate

extension NotificationController: NotificationCellDelegate {
    func cell(_ cell: NotificationCell, wantsToFollow uid: String) {
        showLoader(true)
        
        UserService.follow(uid: uid) { _ in
            cell.viewModel?.notification.userIsFollowd.toggle()
            
            DispatchQueue.main.async {
                self.showLoader(false)
            }
        }
    }
    
    func cell(_ cell: NotificationCell, wantsToUnfollow uid: String) {
        showLoader(true)

        UserService.unfollow(uid: uid) { _ in
            cell.viewModel?.notification.userIsFollowd.toggle()
            
            DispatchQueue.main.async {
                self.showLoader(false)
            }
        }
    }
    
    func cell(_ cell: NotificationCell, wantsToViewPost postId: String) {
        showLoader(true)

        PostService.fetchPost(withPostId: postId) { post in
            DispatchQueue.main.async {
                self.showLoader(false)
            }
            
            let feedVC: FeedController = .init(collectionViewLayout: UICollectionViewFlowLayout())
            feedVC.post = post
            self.navigationController?.pushViewController(feedVC, animated: true)
        }
    }
}

