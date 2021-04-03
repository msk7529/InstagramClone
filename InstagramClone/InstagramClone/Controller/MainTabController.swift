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
        
        let feedVC: UINavigationController = templateNavigationController(unselectedImg: UIImage(named: "home_unselected")!, selectedImg: UIImage(named: "home_selected")!, rootVC: FeedController())
        let searchVC: UINavigationController = templateNavigationController(unselectedImg: UIImage(named: "search_unselected")!, selectedImg: UIImage(named: "search_selected")!, rootVC: SearchController())
        let imageSelectorVC: UINavigationController = templateNavigationController(unselectedImg: UIImage(named: "plus_unselected")!, selectedImg: UIImage(named: "plus_unselected")!, rootVC: ImageSelectorController())
        let notificationVC: UINavigationController = templateNavigationController(unselectedImg: UIImage(named: "like_unselected")!, selectedImg: UIImage(named: "like_selected")!, rootVC: NotificationController())
        let profileVC: UINavigationController = templateNavigationController(unselectedImg: UIImage(named: "profile_unselected")!, selectedImg: UIImage(named: "profile_selected")!, rootVC: ProfileController())
        
        self.viewControllers = [feedVC, searchVC, imageSelectorVC, notificationVC, profileVC]
        self.tabBar.tintColor = .black
    }
    
    private func templateNavigationController(unselectedImg: UIImage, selectedImg: UIImage, rootVC: UIViewController) -> UINavigationController {
        let navigationVC: UINavigationController = .init(rootViewController: rootVC)
        navigationVC.tabBarItem.image = unselectedImg
        navigationVC.tabBarItem.selectedImage = selectedImg
        navigationVC.navigationBar.tintColor = .black
        return navigationVC
    }
}
