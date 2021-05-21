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
    
    var viewModel: CommentViewModel? {
        didSet {
            configure()
        }
    }
    
    private let profileImageView: UIImageView = {
        let imageView: UIImageView = .init()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let commentLabel: UILabel = {
        let label: UILabel = .init()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(profileImageView)
        self.addSubview(commentLabel)
        
        profileImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.layer.cornerRadius = 40 / 2
        
        commentLabel.leftAnchor.constraint(equalTo: self.profileImageView.rightAnchor, constant: 8).isActive = true
        commentLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 8).isActive = true
        commentLabel.centerYAnchor.constraint(equalTo: self.profileImageView.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func configure() {
        guard let viewModel = viewModel else { return }
        
        profileImageView.sd_setImage(with: viewModel.profileImageUrl, completed: nil)
        commentLabel.attributedText = viewModel.commentLabelText()
    }

}
