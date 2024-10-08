//
//  ContentView.swift
//  AITOTO
//
//  Created by  髙橋和 on 2024/07/19.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    @StateObject var registrationViewModel = RegistrationViewModel()

    var body: some View {
        Group {
            if viewModel.userSession == nil {
                LoginView()
                    .environmentObject(registrationViewModel)
            } else if let currentUser = viewModel.currentUser {
                MainView(user: currentUser)
            } //else {
//                //ログインはしているが、ユーザー情報が存在しない場合のハンドリング
//                ProgressView("Loading...") // ローディングビューを表示
//                    .onAppear {
//                        viewModel.forceSignout()
//                    }
//            }
        }
    }
}

#Preview {
    ContentView()
}
