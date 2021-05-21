//
//  CommentService.swift
//  InstagramClone
//
//  Created by kakao on 2021/05/21.
//

import Firebase

struct CommentService {
    static func uploadComment(comment: String, postID: String, user: User, completion: @escaping(FirestoreCompletion)) {
        let data: [String: Any] = ["uid": user.uid,
                                   "comment": comment,
                                   "timestamp": Timestamp(date: Date()),
                                   "username": user.username,
                                   "profileImageUrl": user.profileImageUrl]
        COLLECTION_POSTS.document(postID).collection("comments").addDocument(data: data, completion: completion)
    }
    
    static func fetchComments(forPost postID: String, complection: @escaping([Comment]) -> Void) {
        var comments: [Comment] = []
        let query: Query = COLLECTION_POSTS.document(postID).collection("comments").order(by: "timestamp", descending: true)
        
        // comments가 갱신되면 자동으로 fetch
        query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach { change in
                if change.type == .added {
                    let data: [String: Any] = change.document.data()
                    let comment: Comment = .init(dictionary: data)
                    comments.append(comment)
                }
            }
            complection(comments)
        }
    }
}
