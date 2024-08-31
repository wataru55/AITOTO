//
//  IconRegistrationItemView.swift
//  AITOTO
//
//  Created by  髙橋和 on 2024/08/09.
//

import SwiftUI
import ColorfulX

struct IconRegistrationItemView: View {
    let registration: Registration
    let length = UIScreen.main.bounds.width / 3 - 15

    var body: some View {
        AsyncImage(url: URL(string: registration.imageURL)) { image in
            image
                .resizable()
                .scaledToFill() // フレームにぴったり収まるようにスケーリング
                .frame(width: length, height: length)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.black, lineWidth: 1)
                )
                .clipped() // フレームを超える部分をクリップ
                .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 2)

        } placeholder: {
            // ローディング中やエラー時に表示されるプレースホルダー
            ProgressView()
        }
        .frame(width: length, height: length) // フレームのサイズを固定

    }
}

#Preview {
    IconRegistrationItemView(registration: Registration.MOCK_REGISTRATIONS[0])
}
