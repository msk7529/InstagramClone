//
//  FeedController.swift
//  InstagramClone
//
//  Created by kakao on 2021/04/04.
//

import Firebase
import UIKit

final class FeedController: UICollectionViewController {
    
    // - MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
    }
    
    // - MARK: Helpers
    private func configureUI() {
        collectionView.backgroundColor = .systemBackground

        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.identifier)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.title = "Feed"
    }
    
    // - MARK: Actions
    @objc private func handleLogout() {
        do {
            try Auth.auth().signOut()
            
            DispatchQueue.main.async {
                let controller: LoginController = .init()
                let nav: UINavigationController = .init(rootViewController: controller)
                nav.modalPresentationStyle = . fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        } catch {
            print("DEBUG: Failed to sign out")
        }
    }
}

// - MARK: UICollectionViewDataSource
extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.identifier, for: indexPath) as? FeedCell else {
            return UICollectionViewCell()
        }
        return cell
    }
}

// - MARK: UICollectionViewFlowLayout
extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = view.frame.width
        let height: CGFloat = width + 8 + 40 + 8 + 50 + 60
        // width : 포스트이미지뷰 높이
        // 8 + 40 + 8 : 프로필이미지뷰와 패딩 높이
        // 50 + 60 : 그 아래 높이
        return CGSize(width: width, height: height)
    }
}
