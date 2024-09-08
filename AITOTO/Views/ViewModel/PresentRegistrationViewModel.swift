//
//  RegistrationViewModel.swift
//  AITOTO
//
//  Created by  髙橋和 on 2024/08/05.
//

import SwiftUI
import Firebase
import PhotosUI
import FirebaseStorage

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

        // Firestore内のユーザーの`registrations`コレクションから指定されたドキュメントを参照
        let userRegistrationRef = Firestore.firestore()
            .collection("users")
            .document(uid)
            .collection("registrations")
            .document(documentId)

        // ドキュメントの情報を取得し、ドキュメントが存在していればそのデータを取得
        let document = try await userRegistrationRef.getDocument()

        // ドキュメントの`imageURL`フィールドから画像URLを取得（存在する場合）
        if let data = document.data(), let imageURL = data["imageURL"] as? String {
            // Firebase Storageに保存された画像の参照を取得
            let ref = Storage.storage().reference(forURL: imageURL)

            // Firebase Storageから画像を削除
            do {
                try await ref.delete()  // Firebase Storageの画像を削除
                print("Image deleted successfully from Firebase Storage.")  // 成功メッセージ
            } catch {
                // 画像削除に失敗した場合のエラーハンドリング
                print("Error deleting image from Firebase Storage: \(error.localizedDescription)")
            }
        }

        try await userRegistrationRef.delete()
        print("Registration deleted successfully!")
    }
}
