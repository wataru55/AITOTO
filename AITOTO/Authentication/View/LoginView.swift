//
//  LoginView.swift
//  AITOTO
//
//  Created by  髙橋和 on 2024/07/21.
//

import SwiftUI

struct LoginView: View {
    //MARK: - property
    @StateObject var viewModel = LoginViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()

                Image("logo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 150)
                    .padding(.bottom, 40)
                    .padding(.leading,20)


                VStack (spacing: 15){
                    TextField("電子メールを入力", text: $viewModel.email)
                        .modifier(IGTextFieldModifier())
                    
                    SecureField("パスワードを入力", text: $viewModel.password)
                        .modifier(IGTextFieldModifier())
                } //Vstack

                Button(action: {
                    print("show forgot password")
                }, label: {
                    Text("パスワードを忘れた？")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundStyle(.pink.opacity(0.8))
                        .padding(.top)
                })
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing)
                .padding(.vertical, 5)

                Button(action: {
                    Task { try await viewModel.signIn() } //関数を実行
                }, label: {
                    Text("ログイン")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(width: 360, height: 44)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.pink]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(12)
                        .padding(.top)
                })
                .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 2)

                Spacer()

                Divider()

                NavigationLink {
                    //遷移先のview
                    AddEmailView()
                        .navigationBarBackButtonHidden()
                } label: {
                    HStack {
                        Text("アカウントの新規作成")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundStyle(.pink.opacity(0.8))
                    }
                }
                .padding(.vertical)
            }//vstack
        }//navigationstack
    }
}

#Preview {
    LoginView()
}
