//
//  RegistrationViewModel.swift
//  AITOTO
//
//  Created by  髙橋和 on 2024/08/05.
//

import SwiftUI
import Firebase
import PhotosUI

class PresentRegistrationViewModel: ObservableObject {
    @Published var date = Date()
    @Published var title: String = ""
    @Published var bio: String = ""
    @Published var displayImage: Image?
    @Published var selectedImage: PhotosPickerItem? { //画像へのアクセス権
        didSet { Task { await loadImage(fromItem: selectedImage) } }
    }

    private var uiImage: UIImage?

    @MainActor
    func loadImage(fromItem item: PhotosPickerItem?) async {
        guard let item = item else { return } //アクセス権が正しいか確認

        guard let data = try? await item.loadTransferable(type: Data.self) else { return } //画像データ読み込み

        guard let uiImage = UIImage(data: data) else { return } //画像データをUIImage型（画像データそのもの）に変換
        self.uiImage = uiImage
        self.displayImage = Image(uiImage: uiImage) //UIImageをImage型（SwiftUI の画像表示用オブジェクト）に変換．
    }

    // Firestoreにデータを保存するメソッド
    func saveToFirestore() async throws {
        guard let uid = AuthService.shared.currentUser?.id else { return }
        guard let uiImage = uiImage else { return }

        // 各ユーザーに対してサブコレクションを指定
        let userRegistrationRef = Firestore.firestore()
            .collection("users")
            .document(uid)
            .collection("registrations")
            .document() // 新しいドキュメントを自動生成

        guard let imageUrl = try await ImageLoader.uploadImage(image: uiImage) else { return }
        // Date型をそのまま保存する
        let registration = Registration(id: userRegistrationRef.documentID, ownerUid: uid, imageURL: imageUrl, date: date, title: title, bio: bio)
        guard let encodedInfo = try? Firestore.Encoder().encode(registration) else { return }

        try await userRegistrationRef.setData(encodedInfo)

        print("Registration saved successfully!")
    }


    // 保存内容を変更するメソッド
    func updateFirestoreData(documentId: String) async throws {
        guard let uid = AuthService.shared.currentUser?.id else { return }

        let userRegistrationRef = Firestore.firestore()
            .collection("users")
            .document(uid)
            .collection("registrations")
            .document(documentId)

        // Date型をそのまま保存する
        var updatedData: [String: Any] = [
            "title": title,
            "bio": bio,
            "date": date  // Date型をそのままFirestoreに保存
        ]

        if let uiImage = uiImage {
            guard let imageUrl = try await ImageLoader.uploadImage(image: uiImage) else { return }
            updatedData["imageURL"] = imageUrl
        }

        try await userRegistrationRef.updateData(updatedData)
        print("Registration updated successfully!")
    }

    // Firestoreからドキュメントを削除するメソッド
    func deleteFirestoreData(documentId: String) async throws {
        guard let uid = AuthService.shared.currentUser?.id else { return }

        let userRegistrationRef = Firestore.firestore()
            .collection("users")
            .document(uid)
            .collection("registrations")
            .document(documentId)

        try await userRegistrationRef.delete()
        print("Registration deleted successfully!")
    }

}
