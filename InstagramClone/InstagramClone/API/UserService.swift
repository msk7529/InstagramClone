//
//  UserService.swift
//  InstagramClone
//
//  Created by kakao on 2021/04/18.
//
import Firebase

typealias FirestoreCompletion = (Error?) -> Void

struct UserService {
    static func fetchUser(withUid uid: String, completion: @escaping (User) -> Void) {
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else { return }
            
            let user: User = .init(dictionary: dictionary)
            completion(user)
        }
    }
    
    static func fetchUsers(completion: @escaping ([User]) -> Void) {
        COLLECTION_USERS.getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            
            let users: [User] = snapshot.documents.compactMap { User(dictionary: $0.data()) }
            completion(users)
        }
    }
    
    static func follow(uid: String, completion: @escaping(FirestoreCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).setData([:]) {
            error in
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUid).setData([:], completion: completion)
        }
    }
    
    static func unfollow(uid: String, completion: @escaping(FirestoreCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).delete() { error in
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUid).delete(completion: completion)
        }
    }
    
    static func checkIfUserIsFollowed(uid: String, completion: @escaping (Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }

        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).getDocument { (snapshot, error) in
//            guard let isFollowed = snapshot.exists else { return }
//            completion(isFollowed)
            
            guard let isFollowed = snapshot?.exists, isFollowed == true else {
                completion(false)
                return
            }
            completion(isFollowed)
        }
    }
    
    static func fetchUserStats(uid: String, completion: @escaping (UserStats) -> Void) {
        COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { (snapshot, error) in
            let followers: Int = snapshot?.documents.count ?? 0
            
            COLLECTION_FOLLOWERS.document(uid).collection("user-following").getDocuments { (snapshot, error) in
                let following: Int = snapshot?.documents.count ?? 0
                
                COLLECTION_POSTS.whereField("ownerUid", isEqualTo: uid).getDocuments { (snapshot, _) in
                    let postCount: Int = snapshot?.documents.count ?? 0
                    completion(UserStats(followers: followers, following: following, posts: postCount))
                }
            }
        }
    }
}
