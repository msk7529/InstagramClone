//
//  MainTabController.swift
//  InstagramClone
//
//  Created by kakao on 2021/04/03.
//

import UIKit
import Firebase
import YPImagePicker

final class MainTabController: UITabBarController {
    // MARK: Properties
    var user: User? {
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
        guard let uid = Auth.auth().currentUser?.uid else { return }

        UserService.fetchUser(withUid: uid) { user in
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
        self.delegate = self
        
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
    
    private func didFinishPickingMeida(_ picker: YPImagePicker) {
        picker.didFinishPicking { items, _ in
            picker.dismiss(animated: true) {
                guard let selectedImage = items.singlePhoto?.image else { return }
                
                let uploadPostVC: UploadPostController = .init()
                uploadPostVC.selectedImage = selectedImage
                uploadPostVC.uploadPostCompleted = { [weak self] controller in
                    guard let strongSelf = self else { return }
                    
                    strongSelf.selectedIndex = 0
                    controller.dismiss(animated: true, completion: nil)
                    
                    guard let feedNav = strongSelf.viewControllers?.first as? UINavigationController, let feedVC = feedNav.viewControllers.first as? FeedController else {
                        return
                    }
                    feedVC.handleRefresh()
                }
                //uploadPostVC.delegate = self
                
                let nav: UINavigationController = .init(rootViewController: uploadPostVC)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: false, completion: nil)
            }
        }
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

// MARK: - UITabBarControllerDelegate
extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let selectedVC = (viewController as? UINavigationController)?.viewControllers.first else {
            return false
        }
        //if let index = self.viewControllers?.firstIndex(of: viewController), index == 2 {
        if let _ = selectedVC as? ImageSelectorController {
            var config: YPImagePickerConfiguration = .init()
            config.library.mediaType = .photo
            config.shouldSaveNewPicturesToAlbum = false
            config.startOnScreen = .library
            config.screens = [.library]
            config.hidesStatusBar = false
            config.hidesBottomBar = false
            config.library.maxNumberOfItems = 1
            
            let picker: YPImagePicker = .init(configuration: config)
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true, completion: nil)
            
            didFinishPickingMeida(picker)
        }
        return true
    }
}

// MARK: - UploadPostControllerDelegate
extension MainTabController: UploadPostControllerDelegate {
    func controllerDidFinishUploadingPost(_ controller: UploadPostController) {
        selectedIndex = 0
        controller.dismiss(animated: true, completion: nil)
    }
}
