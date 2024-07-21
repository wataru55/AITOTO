//
//  AddEmailView.swift
//  AITOTO
//
//  Created by  髙橋和 on 2024/07/21.
//

import SwiftUI

struct AddEmailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RegistrationViewModel //クラスのインスタンス化

    var body: some View {
        VStack (spacing: 10) {
            Text("電子メールの登録")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)

            Text("アカウントへのログインに使います")
                .font(.footnote)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .padding(.bottom)


            TextField("電子メール", text: $viewModel.email)
                .autocapitalization(.none) //自動的に大文字にしない
                .modifier(IGTextFieldModifier()) //カスタムモディファイア

            NavigationLink {
                CreateUserNameView()
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

            Spacer() //上に押し上げるため
        }//vstack
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .onTapGesture {
                        dismiss()
                    }
            }
        }
    }//body
}//view

#Preview {
    AddEmailView()
}
