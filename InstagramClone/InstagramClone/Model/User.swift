//
//  User.swift
//  InstagramClone
//
//  Created by kakao on 2021/04/18.
//
import Foundation
import Firebase

struct User {
    let email: String
    let fullname: String
    let profileImageUrl: String
    let username: String
    let uid: String
    
    var isFollowed: Bool = false
    
    var stats: UserStats!
    
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    
    init(dictionary: [String: Any]) {
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.stats = .init(followers: 0, following: 0, posts: 0)  // default value
    }
}

struct UserStats {
    let followers: Int
    let following: Int
    let posts: Int
}
