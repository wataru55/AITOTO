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
        ZStack {
            //background
            LinearGradient(
                    colors: [Color.customBackgroundColor1, Color.customBackgroundColor2],
                    startPoint: .top,
                    endPoint: .bottom
            )
            .ignoresSafeArea()
            VStack{
                Text("PresentRecommendationView")
                    .foregroundStyle(.black)
            }//Vstack
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // 前のビューに戻る
                    }, label: {
                        Image("logo_transparent")
                            .resizable()
                            .frame(width: 100, height: 100)
                    })//button
                }//toolbarItem
            }//toolbar
        }//zstack
    }//body
}//view

#Preview {
    PresentRecommendationView()
}
