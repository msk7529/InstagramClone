//
//  FeedCell.swift
//  InstagramClone
//
//  Created by kakao on 2021/04/04.
//

import UIKit

protocol FeedCellDelegate: AnyObject {
    func cell(_ cell: FeedCell, wantsToShowCommentFor post: Post) // navigationController에서 pushVC는 cell에서 할 수 없고, VC에서만 가능.
    func cell(_ cell: FeedCell, didLike post: Post)
}

final class FeedCell: UICollectionViewCell {
    
    // - MARK: Properties
    static let identifier: String = "FeedCell"
    
    weak var delegate: FeedCellDelegate?
    
    var viewModel: PostViewModel? {
        didSet {
            self.configure()
        }
    }
    
    private let profileImageView: UIImageView = {
        let imageView: UIImageView  = .init()
        imageView.backgroundColor = .lightGray
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 40 / 2
        return imageView
    }()
    
    private lazy var userNameButton: UIButton = {
        let button: UIButton = .init(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(didTapUserName), for: .touchUpInside)
        return button
    }()
    
    private let postImageView: UIImageView = {
        let imageView: UIImageView  = .init()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let button: UIButton = .init(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "like_unselected"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        return button
    }()
    
    private lazy var commentButton: UIButton = {
        let button: UIButton = .init(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "comment"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapComments), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button: UIButton = .init(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "send2"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapUserName), for: .touchUpInside)
        return button
    }()
    
    private let likesLabel: UILabel = {
        let label: UILabel = .init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 13)
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label: UILabel = .init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let postTimeLabel: UILabel = {
        let label: UILabel = .init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2 days ago"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView: UIStackView = .init(arrangedSubviews: [likeButton, commentButton, shareButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // - MARK: LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // - MARK: UI
    private func configureUI() {
        self.backgroundColor = .systemBackground

        self.contentView.addSubview(profileImageView)
        self.contentView.addSubview(userNameButton)
        self.contentView.addSubview(postImageView)
        self.contentView.addSubview(buttonStackView)
        self.contentView.addSubview(likesLabel)
        self.contentView.addSubview(captionLabel)
        self.contentView.addSubview(postTimeLabel)
        
        profileImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 12).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        userNameButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        userNameButton.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        
        postImageView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8).isActive = true
        postImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        postImageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        postImageView.heightAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 1).isActive = true
        
        buttonStackView.topAnchor.constraint(equalTo: postImageView.bottomAnchor).isActive = true
        buttonStackView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        buttonStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        likesLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: -4).isActive = true
        likesLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 8).isActive = true
        
        captionLabel.topAnchor.constraint(equalTo: likesLabel.bottomAnchor, constant: 8).isActive = true
        captionLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 8).isActive = true
        
        postTimeLabel.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 8).isActive = true
        postTimeLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 8).isActive = true
    }
    
    // - MARK: Actions
    @objc private func didTapUserName() {
        
    }
    
    @objc private func didTapComments() {
        guard let viewModel = viewModel else { return }
        
        delegate?.cell(self, wantsToShowCommentFor: viewModel.post)
    }
    
    @objc private func didTapLike() {
        guard let viewModel = viewModel else { return }
        
        delegate?.cell(self, didLike: viewModel.post)
    }
    
    // - MARK: Helpers
    private func configure() {
        guard let viewModel = viewModel else { return }
        
        captionLabel.text = viewModel.caption
        postImageView.sd_setImage(with: viewModel.imageUrl, completed: nil)
        
        profileImageView.sd_setImage(with: viewModel.userProfileImageUrl, completed: nil)
        userNameButton.setTitle(viewModel.username, for: .normal)
        
        likesLabel.text = viewModel.likesLabelText
        
        self.updateLikeButton(didLike: viewModel.post.didLike)
    }
    
    func updateLikeButton(didLike: Bool) {
        if didLike {
            likeButton.setImage(UIImage(named: "like_selected"), for: .normal)
            likeButton.tintColor = .red
        } else {
            likeButton.setImage(UIImage(named: "like_unselected"), for: .normal)
            likeButton.tintColor = .black
        }
    }
}
