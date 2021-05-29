//
//  PostViewModel.swift
//  InstagramClone
//
//  Created by kakao on 2021/05/09.
//
import Foundation

struct PostViewModel {
    var post: Post
    
    var imageUrl: URL? {
        return URL(string: post.imageUrl)
    }
    
    var userProfileImageUrl: URL? {
        return URL(string: post.ownerImageUrl)
    }
    
    var username: String {
        return post.ownerUsername
    }
    
    var caption: String {
        return post.caption
    }
    
    var likes: Int {
        return post.likes
    }
    
    var likesLabelText: String {
        if post.likes != 1 {
            return "\(post.likes) likes"
        } else {
            return "\(post.likes) like"
        }
    }
    
    // 강의에서 likeButtonTintColor, likeButtonImage property 정의.
    
    init(post: Post) {
        self.post = post
    }
}
