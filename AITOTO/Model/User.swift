//
//  User.swift
//  AITOTO
//
//  Created by  髙橋和 on 2024/07/21.
//

import Foundation
import Firebase

struct User: Identifiable, Hashable, Codable {
    let id: String
    var username: String
    var profileImageUrl: String?
    var email: String

    var isCurrentUser: Bool {
        guard let currentUid = Auth.auth().currentUser?.uid else { return false } //現在のユーザ情報があればそれをcurrentUidに格納
        return currentUid == id
    }
}

extension User {
    static var MOCK_USERS: [User] = [
        .init(id: NSUUID().uuidString, username: "ironman", profileImageUrl: "ironman1", email: "ironman@gmail.com"),

        .init(id: NSUUID().uuidString, username: "spiderman", profileImageUrl: "spiderman1", email: "spiderman@gmail.com")
    ]
}
