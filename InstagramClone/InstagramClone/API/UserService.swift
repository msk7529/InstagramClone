//
//  UserService.swift
//  InstagramClone
//
//  Created by kakao on 2021/04/18.
//
import Firebase

struct UserService {
    static func fetchUsers(completion: @escaping (User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else { return }
            
            let user: User = .init(dictionary: dictionary)
            completion(user)
        }
    }
}
