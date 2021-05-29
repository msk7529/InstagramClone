//
//  FeedController.swift
//  InstagramClone
//
//  Created by kakao on 2021/04/04.
//

import Firebase
import UIKit

final class FeedController: UICollectionViewController {
    
    // - MARK: Properties
    private var posts: [Post] = []
    var post: Post?     // nil이 아니면 해당 포스트 한개만 노출되도록.
    
    // - MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.fetchPosts()
    }
    
    // - MARK: API
    private func fetchPosts() {
        guard self.post == nil else { return }
        
        PostService.fetchPosts { posts in
            print("Debug: Did fetch posts")
            self.posts = posts
            self.collectionView.refreshControl?.endRefreshing()
            self.checkIfUserLikedPost()
        }
    }
    
    private func checkIfUserLikedPost() {
        var checkedCount: Int = 0
        
        self.posts.forEach { post in
            PostService.checkIfUserLikedPost(post: post) { didLike in
                checkedCount += 1
                
                if let index = self.posts.firstIndex(where: { $0.postId == post.postId }) {
                    self.posts[index].didLike = didLike
                }
                
                if checkedCount == self.posts.count {
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()    // 강의에선 posts didSet에서 수행하도록 했는데 비효율적인것 같아서 수정
                    }
                }
            }
        }
        
    }
    
    // - MARK: Helpers
    private func configureUI() {
        collectionView.backgroundColor = .systemBackground

        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.identifier)
        
        if post == nil {
            // ProfileVC 로부터 push 될 때 back버튼 가려지는 문제 수정
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
            navigationItem.title = "Feed"
        }

        let refresher: UIRefreshControl = .init()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        collectionView.refreshControl = refresher
    }
    
    // - MARK: Actions
    @objc private func handleLogout() {
        do {
            try Auth.auth().signOut()
            
            DispatchQueue.main.async {
                let controller: LoginController = .init()
                controller.delegate = self.tabBarController as? MainTabController
                let nav: UINavigationController = .init(rootViewController: controller)
                nav.modalPresentationStyle = . fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        } catch {
            print("DEBUG: Failed to sign out")
        }
    }
    
    @objc func handleRefresh() {
        posts.removeAll()
        fetchPosts()
    }
}

// - MARK: UICollectionViewDataSource
extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post == nil ? posts.count : 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.identifier, for: indexPath) as? FeedCell else {
            return UICollectionViewCell()
        }
        
        cell.delegate = self

        if let post = post {
            cell.viewModel = PostViewModel(post: post)
        } else {
            if posts.count > indexPath.row {
                // refresh시 크래시 방어 코드
                cell.viewModel = PostViewModel(post: posts[indexPath.row])
            }
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

// - MARK: FeedCellDelegate
extension FeedController: FeedCellDelegate {
    func cell(_ cell: FeedCell, wantsToShowCommentFor post: Post) {
        let commentVC: CommentController = .init(post: post)
        self.navigationController?.pushViewController(commentVC, animated: true)
    }
    
    func cell(_ cell: FeedCell, didLike post: Post) {
        cell.viewModel?.post.didLike.toggle()   // 강의에서는 PostViewModel의 post가 let인데도 되던데..
        
        if post.didLike {
            PostService.unlikePost(post: post) { _ in
                cell.updateLikeButton(didLike: false)
                cell.viewModel?.post.likes -= 1
            }
        } else {
            PostService.likePost(post: post) { _ in
                cell.updateLikeButton(didLike: true)
                cell.viewModel?.post.likes += 1
            }
        }
    }
}
