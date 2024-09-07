//
//  PresentInfoEditView.swift
//  AITOTO
//
//  Created by  髙橋和 on 2024/08/27.
//

import SwiftUI

struct PresentInfoEditView: View {
    @StateObject var viewModel = PresentRegistrationViewModel()
    @EnvironmentObject var envViewModel: RegistrationItemViewModel

    @State private var isPickerPresented = false // Picker表示状態を管理する変数
    @State private var showAlert = false // アラートの表示状態を管理する変数
    @State private var isEditing = false // 編集中かどうかを管理する変数

    @Environment(\.presentationMode) var presentationMode

    let info: Registration
    let _width = UIScreen.main.bounds.width - 60

    init(info: Registration) {
        self.info = info
        UIDatePicker.appearance().tintColor = .systemPink
    }

    var body: some View {
        VStack {
            ScrollView (.vertical, showsIndicators: false) {
                //MARK: - imageArea
                //photoPickerで選択された画像がある時
                if let displayImage = viewModel.displayImage {
                    displayImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .padding(.vertical, 10)
                        .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 2)
                        .onTapGesture {
                            if isEditing {
                                isPickerPresented.toggle()
                            }
                        }

                } else {
                    //ないときは元の画像を表示
                    AsyncImage(url: URL(string: info.imageURL)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                            .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 2)
                            .onTapGesture {
                                if isEditing {
                                    isPickerPresented.toggle()
                                }
                            }
                    } placeholder: {
                        // ローディング中やエラー時に表示されるプレースホルダー
                        ProgressView()
                    }
                    .frame(width: 300, height: 300)
                    .padding(.top, 20)
                }

                //MARK: - calendarArea
                DatePicker(
                    "Start Date",
                    selection: $viewModel.date,
                    displayedComponents: [.date]
                )
                .foregroundStyle(.black)
                .datePickerStyle(.graphical)
                .frame(width: _width, height: 0)
                .padding(.top, 150)
                .padding(.bottom, 10)
                .allowsHitTesting(isEditing)
                .onAppear {
                    viewModel.date = info.date
                }

                //MARK: - TextFieldArea
                Section {
                    TextField("タイトル", text: $viewModel.title)
                        .frame(width: _width, height: 20)
                        .modifier(IGTextFieldModifier())
                        .shadow(color: isEditing ? .red : .black.opacity(0.7), radius: 2, x: 0, y: 2)
                        .padding(.top, 150)
                        .padding(.bottom, 10)
                        .allowsHitTesting(isEditing)
                        .onAppear() {
                            viewModel.title = info.title
                        }
                } header: {
                    Text("タイトル")
                        .font(.footnote)
                        .foregroundStyle(.black)
                        .frame(width: _width, height: 10, alignment: .leading)
                        .offset(x: -10, y: 150)
                }

                Section {
                    TextField("メモ", text: $viewModel.bio, axis: .vertical)
                        .frame(width: _width, height: 150)
                        .modifier(IGTextFieldModifier())
                        .shadow(color: isEditing ? .red : .black.opacity(0.7), radius: 2, x: 0, y: 2)
                        .allowsHitTesting(isEditing)
                        .onAppear() {
                            if let memo = info.bio {
                                viewModel.bio = memo
                            }
                        }
                } header: {
                    Text("メモ")
                        .font(.footnote)
                        .foregroundStyle(.black)
                        .frame(width: _width, height: 10, alignment: .leading)
                        .offset(x: -10)
                }

                //MARK: - ButtonArea
                HStack {
                    // 編集ボタン
                    Button(action: {
                        isEditing.toggle()
                    }, label: {
                        HStack {
                            Image(systemName: "pencil")
                                .foregroundStyle(isEditing ? .pink : .white)

                            Text(isEditing ? "編集中" : "編集")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(isEditing ? .pink : .white)
                        }
                        .offset(x: -4)
                    })
                    .frame(width: UIScreen.main.bounds.width / 2 - 30, height: 44)
                    .background(isEditing ? .white : .gray)
                    .cornerRadius(12)
                    .compositingGroup()
                    .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 3)

                    // 削除ボタン
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
                                    try await envViewModel.fetchRegistrationsData()
                                    presentationMode.wrappedValue.dismiss()
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
            }//scrollview
            .photosPicker(
                isPresented: $isPickerPresented,
                selection: $viewModel.selectedImage,
                matching: .images
            )
            .onChange(of: viewModel.selectedImage) {
                Task {
                    await viewModel.loadImage(fromItem: viewModel.selectedImage)
                }
            }
        }//vstack
        //MARK: - background
        .background(
            LinearGradient(
                colors: [Color.customBackgroundColor1, Color.customBackgroundColor2],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        //MARK: - NavigationBar
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(Color.customBackgroundColor1, for: .navigationBar)
        .toolbar {
            // ロゴ
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image("logo_transparent")
                        .resizable()
                        .frame(width: 90, height: 90)
                        .padding(.bottom, 5)
                })
            }
            // 保存ボタン
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    Task {
                        do {
                            try await viewModel.updateFirestoreData(documentId: info.id)
                            try await envViewModel.fetchRegistrationsData()
                            isEditing.toggle()
                        } catch {
                            print("Error saving registration: \(error.localizedDescription)")
                        }
                    }

                }, label: {
                    HStack (spacing: 0) {
                        Image(systemName: "square.and.pencil")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.black)

                        Text("変更を保存")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(.black)
                    }
                })
            }
        }//toolbar
    }
}

//#Preview {
//    PresentInfoEditView(info: Registration.MOCK_REGISTRATIONS[0])
//}
