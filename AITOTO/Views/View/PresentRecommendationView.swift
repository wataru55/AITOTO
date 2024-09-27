//
//  PresentRecommendationView.swift
//  AITOTO
//
//  Created by  髙橋和 on 2024/08/02.
//

import SwiftUI

struct PresentRecommendationView: View {
    @Environment(\.presentationMode) var presentationMode

    let _width = UIScreen.main.bounds.width

    var body: some View {
        //MARK: - body
        ZStack {
            LinearGradient(
                colors: [Color.customBackgroundColor1, Color.customBackgroundColor2],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            VStack{
                Spacer()
                VStack (alignment: .leading, spacing: 15){
                    BallonTextView(text: "プレゼント選びって難しいですよね", color: .white.opacity(0.6), mirrored: true)

                    BallonTextView(text: "トトちゃんに相談しておすすめの商品を\n提案してもらいましょう", color: .white.opacity(0.6), mirrored: true)
                }
                .frame(maxWidth: _width)

                Spacer()

                Image("omoidenote_transparent")


                Button {

                } label: {
                    Text("相談する")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(.pink)
                        .cornerRadius(10)
                        .padding(.top, 20)
                }
                .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 2)

                Spacer()

            }//Vstack
            .navigationBarBackButtonHidden(true)
            // MARK: - navigaitonbar
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // 前のビューに戻る
                    }, label: {
                        Image("logo_transparent")
                            .resizable()
                            .frame(width: 90, height: 90)
                    })
                }
            }// toolbar
        }
    }// body
}// PresentRecommendationView

#Preview {
    PresentRecommendationView()
}
