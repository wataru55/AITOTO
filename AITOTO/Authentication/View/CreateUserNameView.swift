//
//  CreateUserNameView.swift
//  AITOTO
//
//  Created by  髙橋和 on 2024/07/21.
//

import SwiftUI

struct CreateUserNameView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RegistrationViewModel //インスタンス化

    var body: some View {
        VStack (spacing: 10) {
            Text("ユーザネームの登録")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)

            Text("""
                 ユーザネームを登録してください
                 いつでも変更できます
                """)
                .font(.footnote)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .padding(.bottom)


            TextField("ユーザネーム", text: $viewModel.username)
                .autocapitalization(.none) //自動的に大文字にしない
                .modifier(IGTextFieldModifier()) //カスタムモディファイア

            NavigationLink {
                CreatePasswordView()
                    .navigationBarBackButtonHidden()
            } label: {
                Text("次へ")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 360, height: 44)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.pink]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(12)
                    .padding(.top)
            }

            Spacer()//上に押し上げる
        }//vstack
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .onTapGesture {
                        dismiss()
                    }
            }
        }//toolbar
    }//body
}//view

#Preview {
    CreateUserNameView()
}
