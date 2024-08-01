//
//  MenuView.swift
//  AITOTO
//
//  Created by  髙橋和 on 2024/07/31.
//

import SwiftUI

struct MenuView: View {
    /// メニュー開閉
    @Binding var isOpen: Bool

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea(.all)
                .opacity(isOpen ? 0.7 : 0)
                .onTapGesture {
                    /// isOpenの変化にアニメーションをつける
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isOpen.toggle()
                    }
                }
            ZStack {
                Color.white
                    .cornerRadius(20.0)
                    .ignoresSafeArea(edges: .bottom)

                VStack{
                    Button(action: {

                    }, label: {
                        HStack {
                            Image(systemName: "gear")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundStyle(.white)

                            Text("設定")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)


                        }
                        .frame(width: 200, height: 44)
                        .background(.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    })
                    .padding(.top, 30)

                    Button(action: {

                    }, label: {
                        HStack {
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundStyle(.white)

                            Text("マイページ")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)


                        }
                        .frame(width: 200, height: 44)
                        .background(.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    })
                    .padding(.top, 10)

                    Button(action: {

                    }, label: {
                        HStack {
                            Image(systemName: "bag")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundStyle(.white)

                            Text("プレミアム")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)


                        }
                        .frame(width: 200, height: 44)
                        .background(.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    })
                    .padding(.top, 10)

                    Button(action: {

                    }, label: {
                        HStack {
                            Image(systemName: "questionmark.circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundStyle(.white)

                            Text("サポート")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)


                        }
                        .frame(width: 200, height: 44)
                        .background(.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    })
                    .padding(.top, 10)

                    Spacer()

                    Button(action: {
                        AuthService.shared.signout()
                    }, label: {
                        Text("ログアウト")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .frame(width: 200, height: 44)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.pink]), startPoint: .leading, endPoint: .trailing))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    })
                    .padding(.top, 40)
                }//vstack
                .frame(width: UIScreen.main.bounds.width * 2 / 3, height: UIScreen.main.bounds.height - 100)
            }//zstack
            /// 画面幅の1/3だけ左側を開ける
            .padding(.leading, UIScreen.main.bounds.width/3)
            /// isOpenで、そのままの位置か、画面幅だけ右にズレるかを決める
            .offset(x: isOpen ? 0 : UIScreen.main.bounds.width)
        }
    }
}

#Preview {
    MenuView(isOpen: .constant(true))
}

