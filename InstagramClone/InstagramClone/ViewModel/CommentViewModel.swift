//
//  CommentViewModel.swift
//  InstagramClone
//
//  Created by kakao on 2021/05/22.
//

import UIKit

struct CommentViewModel {
    private let comment: Comment
    
    var profileImageUrl: URL? {
        return URL(string: comment.profileImageUrl)
    }
    
    init(comment: Comment) {
        self.comment = comment
    }
    
    func commentLabelText() -> NSAttributedString {
        let attributedString: NSMutableAttributedString = .init(string: "\(comment.username) ", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedString.append(NSAttributedString(string: comment.commentText, attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        return attributedString
    }
    
    func size(forWidth width: CGFloat) -> CGSize {
        let label: UILabel = .init()
        label.numberOfLines = 0
        label.text = comment.commentText
        label.lineBreakMode = .byWordWrapping
        label.setWidth(width)
        return label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        // systemLayoutSizeFitting: 현재의 constraint에서 최적의 사이즈
        // layoutFittingCompressedSize: 가능한 가장 작은 사이즈
    }
}
