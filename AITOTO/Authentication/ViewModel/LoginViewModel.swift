//
//  LoginViewModel.swift
//  AITOTO
//
//  Created by  髙橋和 on 2024/07/21.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""

    func signIn() async throws {
        try await AuthService.shared.login(withEmail: email, password: password) //login関数を実行
    }
}
