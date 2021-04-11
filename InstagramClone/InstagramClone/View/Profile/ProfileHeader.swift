//
//  ProfileHeader.swift
//  InstagramClone
//
//  Created by kakao on 2021/04/11.
//
import UIKit

final class ProfileHeader: UICollectionReusableView {
    // MARK: - Properties
    static let identifier: String = "ProfileHeader"

    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
