//
//  ProfileCell.swift
//  InstagramClone
//
//  Created by kakao on 2021/04/11.
//
import UIKit

final class ProfileCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier: String = "ProfileCell"
    
    private let postImageView: UIImageView = {
        let imageView: UIImageView = .init()
        imageView.image = UIImage(named: "venom-7")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemBackground
        
        self.contentView.addSubview(postImageView)
        
        postImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        postImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        postImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        postImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
