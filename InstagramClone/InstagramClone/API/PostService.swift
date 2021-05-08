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
}
