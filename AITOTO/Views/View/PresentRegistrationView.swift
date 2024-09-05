//
//  PresentRegistrationView.swift
//  AITOTO
//
//  Created by  髙橋和 on 2024/08/02.
//

import SwiftUI
import PhotosUI

struct PresentRegistrationView: View {
    @StateObject var viewModel = PresentRegistrationViewModel()
    @EnvironmentObject var envViewModel: RegistrationItemViewModel

    @Environment(\.presentationMode) var presentationMode

    @State private var isPickerPresented = false // Picker表示状態を管理する変数

    let _width = UIScreen.main.bounds.width - 60

    init() {
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
                ScrollView(.vertical, showsIndicators: false) {
                    if let displayImage = viewModel.displayImage {
                        displayImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300) // 画像のサイズを指定
                            .padding(.vertical, 10)
                            .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 2)
                            .onTapGesture {
                                isPickerPresented.toggle()
                            }

                    } else {
                        Button {
                            isPickerPresented.toggle()
                        } label: {
                            Image(systemName: "photo")
                                .foregroundStyle(.black)
                                .frame(width: _width, height: 100)
                                .overlay(.black, in: RoundedRectangle(cornerRadius: 12).stroke(style: .init(lineWidth: 2, dash: [2, 4])))
                                .padding(.top, 20)
                        }
                        .padding(.bottom, 20)
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

                    TextField("タイトル", text: $viewModel.title)
                        .frame(width: _width, height: 20)
                        .modifier(IGTextFieldModifier())
                        .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 2)
                        .padding(.top, 150)
                        .padding(.bottom, 10)

                    TextField("メモ", text: $viewModel.bio, axis: .vertical)
                        .frame(width: _width, height: 150)
                        .modifier(IGTextFieldModifier())
                        .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 2)

                }//scrollView
            }//vstack
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
            .navigationBarBackButtonHidden(true)
            .toolbarBackground(Color.customBackgroundColor1, for: .navigationBar)
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

                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        Task {
                            do {
                                try await viewModel.saveToFirestore()
                                try await envViewModel.fetchRegistrationsData()
                                presentationMode.wrappedValue.dismiss()
                            } catch {
                                print("Error saving registration: \(error.localizedDescription)")
                            }
                        }

                    }, label: {
                        HStack{
                            Image(systemName: "plus.app")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundStyle(.black)

                            Text("登録")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                        }
                    })
                }
            }//toolbar
        }//zstack
    }//body
}//view

#Preview {
    PresentRegistrationView()
}
