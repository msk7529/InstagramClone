//
//  MainTabController.swift
//  InstagramClone
//
//  Created by kakao on 2021/04/03.
//

import UIKit

final class MainTabController: UITabBarController {
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureViewControllers()
    }

    // MARK: Helpers
    private func configureViewControllers() {
        self.view.backgroundColor = .systemBackground
        
        let feedVC: FeedController = .init()
        let searchVC: SearchController = .init()
        let imageSelectorVC: ImageSelectorController = .init()
        let notificationVC: NotificationController = .init()
        let profileVC: ProfileController = .init()
        
        self.viewControllers = [feedVC, searchVC, imageSelectorVC, notificationVC, profileVC]
    }
}
