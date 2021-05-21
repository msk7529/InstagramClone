//
//  CommentController.swift
//  InstagramClone
//
//  Created by kakao on 2021/05/16.
//

import UIKit

final class CommentController: UICollectionViewController {

    // MARK: - Properties
    private let post: Post
    private var comments: [Comment] = []
    
    private lazy var commentInputView: CommentInputAccesoryView = {
        let frame: CGRect = .init(x: 0, y: 0, width: view.frame.width, height: 50)
        let inputView: CommentInputAccesoryView = .init(frame: frame)
        inputView.translatesAutoresizingMaskIntoConstraints = false
        inputView.delegate = self
        return inputView
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return commentInputView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - LifeCycle
    
    init(post: Post) {
        self.post = post
        
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureCollectionView()
        self.fetchComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - API
    private func fetchComments() {
        CommentService.fetchComments(forPost: post.postId) { comments in
            self.comments = comments
            self.collectionView.reloadData()
        }
    }

    
    // MARK: - Helpers
    private func configureCollectionView() {
        self.navigationItem.title = "Comments"
            
        collectionView.backgroundColor = .systemBackground
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: CommentCell.identifier)
        collectionView.alwaysBounceVertical = true  // bounds on
        //collectionView.keyboardDismissMode = .interactive   // 드래그에 따라 키보드가 조절되게끔 하는 옵션
        collectionView.keyboardDismissMode = .onDrag
    }
}

// MARK: - UICollectionViewDataSource
extension CommentController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCell.identifier, for: indexPath) as? CommentCell else {
            return UICollectionViewCell()
        }
        
        cell.viewModel = CommentViewModel(comment: comments[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewFlowLayout
extension CommentController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel: CommentViewModel = .init(comment: comments[indexPath.row])
        let height: CGFloat = viewModel.size(forWidth: view.frame.width).height + 32.0
        return CGSize(width: view.frame.width, height: height)
    }
}

// MARK: - CommentInputAccesoryViewDelegate
extension CommentController: CommentInputAccesoryViewDelegate {
    func inputView(_ inputView: CommentInputAccesoryView, wantsToUploadComment comment: String) {
        guard let tabBarController = self.tabBarController as? MainTabController, let user = tabBarController.user else {
            return
        }
        
        self.showLoader(true)
        
        CommentService.uploadComment(comment: comment, postID: post.postId, user: user) { error in
            self.showLoader(false)
            inputView.clearCommentTextView()
        }
    }
}
