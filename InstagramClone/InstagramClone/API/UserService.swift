//
//  UserService.swift
//  InstagramClone
//
//  Created by kakao on 2021/04/18.
//
import Firebase

struct UserService {
    static func fetchUser(completion: @escaping (User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
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
            print(users)
            completion(users)
        }
    }
}
