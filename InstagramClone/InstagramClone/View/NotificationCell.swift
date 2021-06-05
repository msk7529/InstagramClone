//
//  NotificationCell.swift
//  InstagramClone
//
//  Created by kakao on 2021/06/06.
//

import UIKit

final class NotificationCell: UITableViewCell {
    // MARK: - Properties
    static let identifier: String = "NotificationCell"

    private let profileImageView: UIImageView = {
        let imageView: UIImageView = .init()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.image = UIImage(named: "venom-7")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let infoLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .boldSystemFont(ofSize: 14)
        label.text = "venom"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let postImageView: UIImageView = {
        let imageView: UIImageView = .init()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let tapRecognizer: UITapGestureRecognizer = .init(target: self, action: #selector(handlePostTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapRecognizer)
        
        return imageView
    }()
    
    private let followButton: UIButton = {
        let button: UIButton = .init(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        self.contentView.addSubview(profileImageView)
        self.contentView.addSubview(infoLabel)
        self.contentView.addSubview(followButton)
        self.contentView.addSubview(postImageView)
        
        profileImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 12).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.layer.cornerRadius = 48 / 2
        
        infoLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        infoLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        
        followButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        followButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -12).isActive = true
        followButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        followButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        postImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        postImageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -12).isActive = true
        postImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        postImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        followButton.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions

    @objc private func handleFollowTapped() {
        
    }
    
    @objc private func handlePostTapped() {
        
    }
}
