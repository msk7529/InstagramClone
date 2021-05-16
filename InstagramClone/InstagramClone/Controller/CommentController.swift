//
//  CommentController.swift
//  InstagramClone
//
//  Created by kakao on 2021/05/16.
//

import UIKit

final class CommentController: UICollectionViewController {

    // MARK: - Properties
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureCollectionView()
    }
    
    // MARK: - Helpers
    private func configureCollectionView() {
        self.navigationItem.title = "Comments"
            
        collectionView.backgroundColor = .systemBackground
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: CommentCell.identifier)
    }
}

// MARK: - UICollectionViewDataSource
extension CommentController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCell.identifier, for: indexPath) as? CommentCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .red
        return cell
    }
}

// MARK: - UICollectionViewFlowLayout
extension CommentController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
}
