//
//  UserService.swift
//  AITOTO
//
//  Created by  髙橋和 on 2024/07/21.
//

import Foundation
import Firebase

struct UserService {
    static func fetchUser(withUid uid: String) async throws -> User {
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument() //ユーザidを使用してFirestoreDatabaseからドキュメントを取得
        return try snapshot.data(as: User.self) //snapshotからUser型にデータをデコードして値を返す
    }

    static func fetchRegistrationsDocuments(withUid uid: String) async throws -> [Registration] {

        let snapshot = try await Firestore.firestore().collection("users").document(uid).collection("registrations").getDocuments()

        let registrations = snapshot.documents.compactMap { document -> Registration? in
            try? document.data(as: Registration.self)
        }
        return registrations
    }
}
