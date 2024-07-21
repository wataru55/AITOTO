//
//  CompleteSignUpView.swift
//  AITOTO
//
//  Created by  髙橋和 on 2024/07/21.
//

import SwiftUI

struct CompleteSignUpView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RegistrationViewModel

    var body: some View {
        VStack (spacing: 10) {
            Text("\(viewModel.username)")
                .multilineTextAlignment(.center)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)

            Text("おもいでノートへようこそ！")
                .multilineTextAlignment(.center)
                .font(.title2)
                .fontWeight(.bold)

            Text("下のボタンを押して，おもいでノートを始めよう")
                .font(.footnote)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .padding(.bottom)

            Button(action: {
                Task { try await viewModel.createUser() } //Userを作成
            }, label: {
                Text("登録を完了")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 360, height: 44)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.pink]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(12)
                    .padding(.top)
            })
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .onTapGesture {
                        dismiss()
                    }
            }
        }
    }
}

#Preview {
    CompleteSignUpView()
}
