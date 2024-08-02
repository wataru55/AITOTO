//
//  PresentRecommendationView.swift
//  AITOTO
//
//  Created by  髙橋和 on 2024/08/02.
//

import SwiftUI

struct PresentRecommendationView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack{
            Text("PresentRecommendationView")
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // 前のビューに戻る
                }, label: {
                    Image("logo")
                        .resizable()
                        .frame(width: 100, height: 100)
                })
            }
        }
    }
}

#Preview {
    PresentRecommendationView()
}
