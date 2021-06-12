//
//  PostService.swift
//  InstagramClone
//
//  Created by kakao on 2021/05/09.
//
import UIKit
import Firebase

struct PostService {
    static func uploadPost(caption: String, image: UIImage, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ImageUploader.uploadImage(image: image) { imageUrl in
            let data: [String: Any] = ["caption": caption,
                                       "timestamp": Timestamp(date: Date()),
                                       "likes": 0,
                                       "imageUrl": imageUrl,
                                       "ownerUid": uid]
            COLLECTION_POSTS.addDocument(data: data, completion: completion)
        }
    }
    
    static func fetchPosts(completion: @escaping([Post]) -> Void) {
        COLLECTION_POSTS.order(by: "timestamp", descending: true).getDocuments { (snapshot, error) in
            // 강의에서는 uploadPost 메서드에서 ownerImageUrl, ownerUsername 필드를 추가해주는 방식을 사용.
            guard let documents = snapshot?.documents else { return }
            
            DispatchQueue.global().async {
                var posts: [Post] = []
                documents.forEach {
                    var dic: [String: Any] = $0.data()
                    let documentID: String = $0.documentID
                    
                    let ownerUid: String = dic["ownerUid"] as? String ?? ""
                    UserService.fetchUser(withUid: ownerUid) { user in
                        dic["ownerImageUrl"] = user.profileImageUrl
                        dic["ownerUsername"] = user.username
                        posts.append(Post(postId: documentID, dictionary: dic))
                        
                        if posts.count == documents.count {
                            DispatchQueue.main.async {
                                // 여기서 한번 더 sort 처리
                                posts.sort { $0.timestamp.compare($1.timestamp) == .orderedDescending }
                                completion(posts)
                            }
                        }
                    }
                }
            }
        }
    }
    
    static func fetchPosts(forUser uid: String, completion: @escaping ([Post]) -> Void) {
        let query: Query = COLLECTION_POSTS
            //.order(by: "timestamp", descending: true)  버그가 있어서 제거
            .whereField("ownerUid", isEqualTo: uid)
        
        query.getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else { return }
            
            DispatchQueue.global().async {
                var posts: [Post] = []
                documents.forEach {
                    var dic: [String: Any] = $0.data()
                    let documentID: String = $0.documentID
                    
                    UserService.fetchUser(withUid: uid) { user in
                        dic["ownerImageUrl"] = user.profileImageUrl
                        dic["ownerUsername"] = user.username
                        posts.append(Post(postId: documentID, dictionary: dic))
                        
                        if posts.count == documents.count {
                            DispatchQueue.main.async {
                                // 여기서 한번 더 sort 처리
                                posts.sort { $0.timestamp.compare($1.timestamp) == .orderedDescending }
                                completion(posts)
                            }
                        }
                    }
                }
            }
        }
    }
    
    static func fetchPost(withPostId postId: String, completion: @escaping (Post) -> Void) {
        COLLECTION_POSTS.document(postId).getDocument { snapshot, _ in
            guard let snapshot = snapshot, var dic = snapshot.data() else { return }
            
            UserService.fetchUser(withUid: dic["ownerUid"] as? String ?? "") { user in
                dic["ownerImageUrl"] = user.profileImageUrl
                dic["ownerUsername"] = user.username
                
                let post = Post(postId: snapshot.documentID, dictionary: dic)
                completion(post)
            }
        }
    }
    
    static func likePost(post: Post, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_POSTS.document(post.postId).updateData(["likes": post.likes + 1])
        
        COLLECTION_POSTS.document(post.postId).collection("post-likes").document(uid).setData([:]) { _ in
            COLLECTION_USERS.document(uid).collection("user-likes").document(post.postId).setData([:], completion: completion)
        }
    }
    
    static func unlikePost(post: Post, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid, post.likes > 0 else { return }

        COLLECTION_POSTS.document(post.postId).updateData(["likes": post.likes - 1])

        COLLECTION_POSTS.document(post.postId).collection("post-likes").document(uid).delete { _ in
            COLLECTION_USERS.document(uid).collection("user-likes").document(post.postId).delete(completion: completion)
        }
    }
    
    static func checkIfUserLikedPost(post: Post, completion: @escaping (Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        COLLECTION_USERS.document(uid).collection("user-likes").document(post.postId).getDocument { snapshot, _ in
            guard let didLike = snapshot?.exists else { return }
            completion(didLike)
        }
    }
}
