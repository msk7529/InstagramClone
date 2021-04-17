//
//  ProfileHeaderViewModel.swift
//  InstagramClone
//
//  Created by kakao on 2021/04/18.
//

import Foundation

struct ProfileHeaderViewModel {
    let user: User
    
    var fullname: String {
        return user.fullname
    }
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
        
    init(user: User) {
        self.user = user
    }
}
