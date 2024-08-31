//
//  PresentInfoEditView.swift
//  AITOTO
//
//  Created by  髙橋和 on 2024/08/27.
//

import SwiftUI

struct PresentInfoEditView: View {
    @StateObject var viewModel = PresentRegistrationViewModel()

    @Environment(\.presentationMode) var presentationMode

    @State private var isPickerPresented = false // Picker表示状態を管理する変数

    @Binding var path: NavigationPath

    let info: Registration

    let _width = UIScreen.main.bounds.width - 60

    init(info: Registration, path: Binding<NavigationPath>) {
        self.info = info
        self._path = path
        UIDatePicker.appearance().tintColor = .systemPink
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.customBackgroundColor1, Color.customBackgroundColor2],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack {
                ScrollView (.vertical, showsIndicators: false) {
                    //photoPickerで選択された画像がある時
                    if let displayImage = viewModel.displayImage {
                        displayImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                            .padding(.vertical, 10)
                            .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 2)
                            .onTapGesture {
                                isPickerPresented.toggle()
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
                                    isPickerPresented.toggle()
                                }
                        } placeholder: {
                            // ローディング中やエラー時に表示されるプレースホルダー
                            ProgressView()
                        }
                        .frame(width: 300, height: 300)
                        .padding(.top, 20)
                    }

                    DatePicker(
                        "Start Date",
                        selection: $viewModel.date,
                        displayedComponents: [.date]
                    )
                    .foregroundStyle(.black)
                    .datePickerStyle(.graphical)
                    .frame(width: _width, height: 0)
                    .padding(.top, 150)
                    .padding(.bottom, 30)
                    .onAppear {
                        viewModel.setDate(from: info.date)
                    }

                    TextField("タイトル", text: $viewModel.title)
                        .frame(width: _width, height: 20)
                        .modifier(IGTextFieldModifier())
                        .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 2)
                        .padding(.top, 150)
                        .padding(.bottom, 10)
                        .onAppear() {
                            viewModel.title = info.title
                        }

                    TextField("メモ", text: $viewModel.bio, axis: .vertical)
                        .frame(width: _width, height: 150)
                        .modifier(IGTextFieldModifier())
                        .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 2)
                        .onAppear() {
                            if let memo = info.bio {
                                viewModel.bio = memo
                            }
                        }

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
            .toolbarBackground(Color.customBackgroundColor1, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Button(action: {
                        path.removeLast(path.count)
                    }, label: {
                        Image("logo_transparent")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .padding(.top, 10)

                    })
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        Task {
                            do {
                                try await viewModel.updateFirestoreData(documentId: info.id)
                                presentationMode.wrappedValue.dismiss()
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
        }//zstack
    }
}

//#Preview {
//    PresentInfoEditView(info: Registration.MOCK_REGISTRATIONS[0])
//}
