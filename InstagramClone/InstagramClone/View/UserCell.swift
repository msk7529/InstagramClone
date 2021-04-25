//
//  UserCell.swift
//  InstagramClone
//
//  Created by kakao on 2021/04/18.
//

import UIKit

final class UserCell: UITableViewCell {
    static let identifier: String = "UserCell"
    
    // MARK: - Properties
    var user: User? {
        didSet {
            guard let user = user else { return }
            
            usernameLabel.text = user.username
            fullnameLabel.text = user.fullname
        }
    }
    
    private let profileImageView: UIImageView = {
        let imageView: UIImageView = .init()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.image = UIImage(named: "venom-7")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .boldSystemFont(ofSize: 14)
        label.text = "venom"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let fullnameLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .systemFont(ofSize: 14)
        label.text = "Eddie Brock"
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView: UIStackView = .init(arrangedSubviews: [usernameLabel, fullnameLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(profileImageView)
        self.contentView.addSubview(labelStackView)
        
        profileImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 12).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.layer.cornerRadius = 48 / 2
        
        labelStackView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        labelStackView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
