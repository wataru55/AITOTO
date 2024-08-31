//
//  PresentInfoView.swift
//  AITOTO
//
//  Created by  髙橋和 on 2024/08/09.
//

import SwiftUI

//登録情報を表示するビュー

struct PresentInfoView: View {
    @StateObject var viewModel = PresentRegistrationViewModel()

    @State private var showAlert = false // アラートの表示状態を管理する変数
    @Binding var path: NavigationPath

    let info: Registration

    let _width = UIScreen.main.bounds.width - 60

    var body: some View {

        ZStack {
            LinearGradient(
                colors: [Color.customBackgroundColor1, Color.customBackgroundColor2],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack {
                AsyncImage(url: URL(string: info.imageURL)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                    //.padding(.vertical, 20)
                        .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 2)

                } placeholder: {
                    // ローディング中やエラー時に表示されるプレースホルダー
                    ProgressView()
                }
                .frame(width: 300, height: 300)
                .padding(.top, 30)

                Section {
                    Text(info.date)
                        .foregroundStyle(.black)
                        .frame(width: _width, height: 40)
                        .background(
                            Color.white
                                .cornerRadius(12)
                            //.shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 2)
                        )

                } header: {
                    Text("登録した日付")
                        .font(.footnote)
                        .foregroundStyle(.black)
                        .frame(width: _width, height: 10, alignment: .leading)
                        .offset(x: -10)
                        .padding(.top, 10)
                }

                Section {
                    Text(info.title)
                        .foregroundStyle(.black)
                        .frame(width: _width, height: 40)
                        .background(
                            Color.white
                                .cornerRadius(12)
                        )


                } header: {
                    Text("タイトル")
                        .font(.footnote)
                        .foregroundStyle(.black)
                        .frame(width: _width, height: 10, alignment: .leading)
                        .offset(x: -10)
                        .padding(.top, 10)
                }

                Section {
                    VStack {
                        ScrollView(.vertical) {
                            VStack {
                                Spacer() // 上部の余白
                                Text(info.bio ?? "")
                                    .padding()
                                    .foregroundStyle(.black)
                                    .multilineTextAlignment(.leading)
                                Spacer() // 下部の余白
                            }
                            .frame(maxWidth: .infinity)
                            .frame(minHeight: 150) // 最小の高さを指定して、中央揃えを維持
                        }
                    }
                    .frame(width: _width, height: 150)
                    .background(
                        Color.white
                            .cornerRadius(12)
                    )
                }
            header: {
                Text("メモ")
                    .font(.footnote)
                    .foregroundStyle(.black)
                    .frame(width: _width, height: 10, alignment: .leading)
                    .offset(x: -10)
                    .padding(.top, 10)
            }

                HStack {
                    NavigationLink (destination: PresentInfoEditView(info: info, path: $path)) {
                        HStack {
                            Image(systemName: "pencil")
                                .foregroundStyle(.white)

                            Text("編集")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        }
                        .offset(x: -4)
                    }
                    .frame(width: UIScreen.main.bounds.width / 2 - 30, height: 44)
                    .background(.gray)
                    .cornerRadius(12)
                    .compositingGroup()
                    .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 3)

                    Button(action: {
                        showAlert.toggle()
                    }, label: {
                        HStack {
                            Image(systemName: "eraser.fill")
                                .foregroundStyle(.white)

                            Text("削除")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .background(.pink)
                        }
                        .offset(x: -4)
                    })
                    .frame(width: UIScreen.main.bounds.width / 2 - 30, height: 44)
                    .background(.pink)
                    .cornerRadius(12)
                    .compositingGroup()
                    .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 3)
                    .alert("本当に削除しますか", isPresented: $showAlert) {
                        Button("はい") {
                            Task {
                                do {
                                    try await viewModel.deleteFirestoreData(documentId: info.id)
                                    path.removeLast(path.count)
                                } catch {
                                    print("Error deleting registration: \(error.localizedDescription)")
                                }
                            }
                        }

                        Button("いいえ") {
                            showAlert.toggle()
                        }
                    }
                } //hstack
                .padding(.top, 20)
            }//vstack
            .offset(x: 0, y: -20.0)
        }//zstack
    }//body
}//view

//#Preview {
//    PresentInfoView(info: Registration.MOCK_REGISTRATIONS[0])
//}
