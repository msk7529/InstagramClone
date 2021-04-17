//
//  ProfileHeader.swift
//  InstagramClone
//
//  Created by kakao on 2021/04/11.
//
import UIKit
import SDWebImage

final class ProfileHeader: UICollectionReusableView {
    // MARK: - Properties
    static let identifier: String = "ProfileHeader"

    var viewModel: ProfileHeaderViewModel? {
        didSet {
            configure()
        }
    }
    
    private let profileImageView: UIImageView = {
        let imageView: UIImageView = .init()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var editProfileFollowButton: UIButton = {
        let button: UIButton = .init(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleEditProfileFollowTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var postLabel: UILabel = {
        let label: UILabel = .init()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.attributedText = attributedStatText(value: 1, label: "posts")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var followersLabel: UILabel = {
        let label: UILabel = .init()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.attributedText = attributedStatText(value: 2, label: "followers")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var followingLabel: UILabel = {
        let label: UILabel = .init()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.attributedText = attributedStatText(value: 1, label: "following")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView: UIStackView = .init(arrangedSubviews: [postLabel, followersLabel, followingLabel])
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let topDivider: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var gridButton: UIButton = {
        let button: UIButton = .init(type: .system)
        button.setImage(UIImage(named: "grid"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var listButton: UIButton = {
        let button: UIButton = .init(type: .system)
        button.setImage(UIImage(named: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var bookmarkButton: UIButton = {
        let button: UIButton = .init(type: .system)
        button.setImage(UIImage(named: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView: UIStackView = .init(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let bottomDivider: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemBackground
        
        self.addSubview(profileImageView)
        self.addSubview(nameLabel)
        self.addSubview(editProfileFollowButton)
        self.addSubview(labelStackView)
        self.addSubview(topDivider)
        self.addSubview(buttonStackView)
        self.addSubview(bottomDivider)
        
        profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.layer.cornerRadius = 80 / 2
        
        nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 12).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        
        editProfileFollowButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16).isActive = true
        editProfileFollowButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 24).isActive = true
        editProfileFollowButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -24).isActive = true
        
        labelStackView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        labelStackView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        labelStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        labelStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        buttonStackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        buttonStackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        buttonStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        buttonStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        topDivider.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        topDivider.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        topDivider.topAnchor.constraint(equalTo: buttonStackView.topAnchor).isActive = true
        topDivider.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        bottomDivider.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        bottomDivider.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        bottomDivider.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor).isActive = true
        bottomDivider.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK : - Actions
    @objc private func handleEditProfileFollowTapped() {
        
    }
    
    // MARK : - Helpers
    private func configure() {
        guard let viewModel = viewModel else { return }
        
        nameLabel.text = viewModel.fullname
        profileImageView.sd_setImage(with: viewModel.profileImageUrl, completed: nil)
    }
    
    private func attributedStatText(value: Int, label: String) -> NSAttributedString {
        let attributedText: NSMutableAttributedString = .init(string: "\(value)\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: label, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.lightGray]))
        return attributedText
    }
}
