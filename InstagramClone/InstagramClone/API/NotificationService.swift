//
//  NotificationService.swift
//  InstagramClone
//
//  Created by kakao on 2021/06/06.
//

import Firebase

struct NotificationService {
    static func uploadNotification(toUid uid: String, fromUser: User, type: NotificationType, post: Post? = nil) {
        // 본인에게는 noti를 보내지 않음.
        guard let currentUid = Auth.auth().currentUser?.uid, uid != currentUid else { return }
        
        let docRef: DocumentReference = COLLECTION_NOTIFICATIONS.document(uid).collection("user-notifications").document()
        
        var data: [String: Any] = ["timestmap": Timestamp(date: Date()),
                                   "uid": fromUser.uid,
                                   "type": type.rawValue,
                                   "id": docRef.documentID,
                                   "username": fromUser.username,
                                   "userProfileImageUrl": fromUser.profileImageUrl]
        
        if let post = post {
            data["postId"] = post.postId
            data["postImageUrl"] = post.imageUrl
        }
        
        docRef.setData(data)
    }
    
    static func fetchNotification(completion: @escaping ([Notification]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_NOTIFICATIONS.document(uid).collection("user-notifications").getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            
            let notification: [Notification] = documents.map { Notification(dictionary: $0.data()) }
            completion(notification)
        }
    }
}
