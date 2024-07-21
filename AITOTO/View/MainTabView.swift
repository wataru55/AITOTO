//
//  RootView.swift
//  AITOTO
//
//  Created by  髙橋和 on 2024/07/21.
//

import SwiftUI

struct MainTabView: View {
    let user: User

    var body: some View {
        Button(action: {
            AuthService.shared.signout()
        }, label: {
            Text("ログアウト")
        })
    }
}

#Preview {
    MainTabView(user: User.MOCK_USERS[0])
}
