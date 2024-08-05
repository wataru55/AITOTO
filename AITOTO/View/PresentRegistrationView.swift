//
//  PresentRegistrationView.swift
//  AITOTO
//
//  Created by  髙橋和 on 2024/08/02.
//

import SwiftUI
import PhotosUI

struct PresentRegistrationView: View {
    @State private var isPickerPresented = false // Picker表示状態を管理する変数

    @StateObject var viewModel = PresentRegistrationViewModel()

    @Environment(\.presentationMode) var presentationMode

    init() {
        UIDatePicker.appearance().tintColor = .systemPink
    }

    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                if let displayImage = viewModel.displayImage {
                    displayImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300) // 画像のサイズを指定
                        .padding(.vertical, 10)
                        .onTapGesture(perform: {
                            isPickerPresented.toggle()
                        })

                } else {
                    Button {
                        isPickerPresented.toggle()
                    } label: {
                        Image(systemName: "photo")
                            .foregroundStyle(.black)
                            .frame(width: 350, height: 100)
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
                .datePickerStyle(.graphical)
                .frame(width: 350, height: 0)
                .padding(.top, 150)
                .padding(.bottom, 30)

                TextField("タイトル", text: $viewModel.title)
                    .autocapitalization(.none) //自動的に大文字にしない
                    .modifier(IGTextFieldModifier())
                    .padding(.top, 150)
                    .padding(.bottom, 10)

                TextField("メモ", text: $viewModel.bio)
                    .autocapitalization(.none) //自動的に大文字にしない
                    .font(.subheadline)
                    .padding(12)
                    .frame(width: UIScreen.main.bounds.width - 30, height: 150)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
            }//scrollView
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

            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    Task {
                        do {
                            try await viewModel.saveToFirestore()
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
    }
}

#Preview {
    PresentRegistrationView()
}
