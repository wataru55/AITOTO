//
//  ListRegistrationItemView.swift
//  AITOTO
//
//  Created by  髙橋和 on 2024/08/09.
//

import SwiftUI

struct ListRegistrationItemView: View {
    let registration: Registration

    let _width = UIScreen.main.bounds.width - 40

    // DateFormatterを使ってDateをStringに変換
        private var formattedDate: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"  // 表示フォーマットを設定
            return dateFormatter.string(from: registration.date)
        }

    var body: some View {
        AsyncImage(url: URL(string: registration.imageURL)) { image in
            image
                .frame(width: _width, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .scaledToFill()
                .opacity(0.2)
                .background(
                    Color.white
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 2)
                )
                .overlay(alignment: .center) {
                    Text(registration.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                        .frame(width: _width, height: 60)
                }

        } placeholder: {
            ProgressView()
        }
        .frame(width: _width, height: 60)
        .overlay(alignment: .topLeading) {
            Text(formattedDate)
                .font(.footnote)
                .foregroundStyle(.black)
                .frame(width: _width, height: 60, alignment: .topLeading)
                .padding(.top, 10)
                .offset(x: 7.0, y: -5.0)
        }
    }
}

#Preview {
    ListRegistrationItemView(registration: Registration.MOCK_REGISTRATIONS[0])
}
