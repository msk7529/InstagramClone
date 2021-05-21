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
}
