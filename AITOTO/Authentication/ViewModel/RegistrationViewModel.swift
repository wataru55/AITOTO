//
//  RegistrationViewModel.swift
//  AITOTO
//
//  Created by  髙橋和 on 2024/07/21.
//

import Foundation

class RegistrationViewModel: ObservableObject {
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""

    @MainActor
    func createUser() async throws {
        try await AuthService.shared.createUser(email: email, password: password, username: username) //ユーザー作成
        //初期化
        username = ""
        email = ""
        password = ""
    }
}
