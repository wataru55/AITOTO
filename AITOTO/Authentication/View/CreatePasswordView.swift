//
//  CreatePasswordView.swift
//  AITOTO
//
//  Created by  髙橋和 on 2024/07/21.
//

import SwiftUI

struct CreatePasswordView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RegistrationViewModel

    var body: some View {
        VStack (spacing: 10) {
            Text("パスワードの登録")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)

            Text("６文字以上でパスワードを登録してください")
                .font(.footnote)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .padding(.bottom)


            TextField("パスワード", text: $viewModel.password)
                .autocapitalization(.none) //自動的に大文字にしない
                .modifier(IGTextFieldModifier())

            NavigationLink {
                CompleteSignUpView()
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

            Spacer()
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
    CreatePasswordView()
}
