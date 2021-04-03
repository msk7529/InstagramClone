//
//  FeedController.swift
//  InstagramClone
//
//  Created by kakao on 2021/04/04.
//

import UIKit

final class FeedController: UICollectionViewController {
    private static let cellIdentifier: String = "feedCell"
    
    // - MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
    }
    
    // - MARK: Helpers
    private func configureUI() {
        collectionView.backgroundColor = .systemBackground

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Self.cellIdentifier)
    }
}

// - MARK: UICollectionViewDataSource
extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.cellIdentifier, for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
}

// - MARK: UICollectionViewFlowLayout
extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
}
