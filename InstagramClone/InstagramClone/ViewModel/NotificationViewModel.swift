//
//  NotificationViewModel.swift
//  InstagramClone
//
//  Created by kakao on 2021/06/06.
//

import UIKit

struct NotificationViewModel {
    let notification: Notification
    
    init(notification: Notification) {
        self.notification = notification
    }
    
    var postImageUrl: URL? {
        return URL(string: notification.postImageUrl ?? "")
    }
    
    var profileImageUrl: URL? {
        return URL(string: notification.userProfileImageUrl ?? "")
    }
    
    var notificationMessage: NSAttributedString {
        let username: String = notification.username
        let message: String = notification.type.notificationMessage
        
        let attributedText: NSMutableAttributedString = .init(string: username, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: message, attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: "  2m", attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.lightGray]))
        
        return attributedText
    }
    
    var shouldHidePostImage: Bool {
        return self.notification.type == .follow
    }
    
    var shouldHideFollowButton: Bool {
        return self.notification.type != .follow
    }
    
    var followButtonText: String {
        return notification.userIsFollowd ? "Following" : "Follow"
    }
}
