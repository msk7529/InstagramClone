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
        COLLECTION_POSTS.getDocuments { (snapshot, error) in
            // 강의에서는 uploadPost 메서드에서 ownerImageUrl, ownerUsername 필드를 추가해주는 방식을 사용.
            guard let documents = snapshot?.documents else { return }
            
            DispatchQueue.global().async {
                var posts: [Post] = []
                documents.forEach {
                    var dic: [String: Any] = $0.data()
                    let documentID: String = $0.documentID
                    
                    let ownerUid: String = dic["ownerUid"] as? String ?? ""
                    UserService.fetchCertainUser(targetUid: ownerUid) { user in
                        dic["ownerImageUrl"] = user.profileImageUrl
                        dic["ownerUsername"] = user.username
                        posts.append(Post(postId: documentID, dictionary: dic))
                        
                        if posts.count == documents.count {
                            DispatchQueue.main.async {
                                completion(posts)
                            }
                        }
                    }
                }
            }
        }
    }
}