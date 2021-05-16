//
//  CommentCell.swift
//  InstagramClone
//
//  Created by kakao on 2021/05/16.
//

import UIKit

final class CommentCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier: String = "CommentCell"
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
