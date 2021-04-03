//
//  FeedCell.swift
//  InstagramClone
//
//  Created by kakao on 2021/04/04.
//

import UIKit

final class FeedCell: UICollectionViewCell {
    
    // - MARK: Properties
    static let identifier: String = "FeedCell"
    
    private let profileImageView: UIImageView = {
        let profileImageView: UIImageView  = UIImageView()
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.isUserInteractionEnabled = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.image = UIImage(named: "venom-7")
        profileImageView.layer.cornerRadius = 40 / 2
        return profileImageView
    }()
    
    private lazy var userNameButton: UIButton = {
        let userNameButton: UIButton = UIButton(type: .system)
        userNameButton.translatesAutoresizingMaskIntoConstraints = false
        userNameButton.setTitle("venom", for: .normal)
        userNameButton.setTitleColor(.black, for: .normal)
        userNameButton.titleLabel?.font = .boldSystemFont(ofSize: 13)
        userNameButton.addTarget(self, action: #selector(didTapUserName), for: .touchUpInside)
        return userNameButton
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
        
        profileImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 12).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        userNameButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        userNameButton.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
    }
    
    // - MARK: Actions
    @objc private func didTapUserName() {
        
    }
}
