//
//  MainTabController.swift
//  InstagramClone
//
//  Created by kakao on 2021/04/03.
//

import UIKit
import Firebase

final class MainTabController: UITabBarController {
    // MARK: Properties
    private var user: User? {
        didSet {
            guard let user = user else { return }
            configureViewControllers(withUser: user)
        }
    }
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground

        checkIfUserIsLoggedIn()
        fetchUser()
    }

    // MARK: API
    private func fetchUser() {
        UserService.fetchUsers { user in
            self.user = user
        }
    }
    
    private func checkIfUserIsLoggedIn() {
        // API 호출이 비동기적으로 메인큐가 아닌 다른 스레드에서 발생할 수 있으므로, LoginController를 메인큐에서 호출함을 보장하기 위해 main thread에서 수행을 강제한다.
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller: LoginController = .init()
                controller.delegate = self
                let nav: UINavigationController = .init(rootViewController: controller)
                nav.modalPresentationStyle = . fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: Helpers
    private func configureViewControllers(withUser user: User) {
        let feedVC: UINavigationController = templateNavigationController(unselectedImg: UIImage(named: "home_unselected")!, selectedImg: UIImage(named: "home_selected")!, rootVC: FeedController(collectionViewLayout: UICollectionViewFlowLayout()))
        // collectionVC는 생성시에 반드시 flowLayout을 지정해주어야 함(layout말고 flowLayout으로.)
        let searchVC: UINavigationController = templateNavigationController(unselectedImg: UIImage(named: "search_unselected")!, selectedImg: UIImage(named: "search_selected")!, rootVC: SearchController())
        let imageSelectorVC: UINavigationController = templateNavigationController(unselectedImg: UIImage(named: "plus_unselected")!, selectedImg: UIImage(named: "plus_unselected")!, rootVC: ImageSelectorController())
        let notificationVC: UINavigationController = templateNavigationController(unselectedImg: UIImage(named: "like_unselected")!, selectedImg: UIImage(named: "like_selected")!, rootVC: NotificationController())
        let profileVC: UINavigationController = templateNavigationController(unselectedImg: UIImage(named: "profile_unselected")!, selectedImg: UIImage(named: "profile_selected")!, rootVC: ProfileController(user: user))
        
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

// MARK: - AuthenticationDelegate
extension MainTabController: AuthenticationDelegate {
    func authenticationDidComplete() {
        print("DEBUG: Auth did complete. Fetch user and update here...")
        fetchUser()
        self.dismiss(animated: true, completion: nil)
    }
}
