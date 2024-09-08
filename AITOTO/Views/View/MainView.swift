//
//  RootView.swift
//  AITOTO
//
//  Created by  髙橋和 on 2024/07/21.
//

import SwiftUI
import Colorful

struct MainView: View {
    @StateObject var viewModel = RegistrationItemViewModel(uid: AuthService.shared.currentUser?.id ?? "")

    @State private var isMenuOpen = false
    @State private var currentSystemImage = "rectangle.grid.1x2"
    @State private var gridLayout: [GridItem] = Array(repeating: .init(.flexible()), count: 3)

    let _width = UIScreen.main.bounds.width - 40
    let user: User

    var body: some View {
        ZStack {
            NavigationStack {
                VStack (alignment: .center){
                    // MARK: - RecommendButtonArea
                    Text("返礼品を探す")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.black)
                        .frame(width: _width, height: 15, alignment: .leading)
                        .padding(.top, 20)

                    NavigationLink(destination: PresentRecommendationView()) {
                        Image("ai_present")
                            .resizable()
                            .scaledToFill()
                            .frame(width: _width, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 12.0))
                            .padding(.bottom, 10)
                            .shadow(color: .black.opacity(0.7), radius: 6, x: 0, y: 5)
                    }

                    Divider()

                    // MARK: - PresentRegistrationArea
                    Text("おもいで記録")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.black)
                        .frame(width: _width, height: 20, alignment: .leading)

                    // プレゼント新規登録ボタン
                    NavigationLink(destination: PresentRegistrationView().environmentObject(viewModel)) {
                        Image(systemName: "plus")
                            .foregroundStyle(.black)
                            .frame(width: _width, height: 55)
                            .overlay(.black, in: RoundedRectangle(cornerRadius: 12).stroke(style: .init(lineWidth: 2, dash: [2, 4])))
                    }
                    
                    // プレゼント一覧リスト
                    ScrollView(.vertical, showsIndicators: false) {
                        if currentSystemImage == "rectangle.grid.1x2" {
                            // リスト型
                            LazyVStack {
                                ForEach(viewModel.RegistrationItem.sorted(by: { $0.date > $1.date }), id: \.self) { item in
                                    NavigationLink(value: item) {
                                        ListRegistrationItemView(registration: item)
                                    }
                                }
                            }
                        } else {
                            // アイコン型
                            LazyVGrid(columns: gridLayout) {
                                ForEach(viewModel.RegistrationItem.sorted(by: { $0.date > $1.date }), id: \.self) { item in
                                    NavigationLink(value: item) {
                                        IconRegistrationItemView(registration: item)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }//scrollview
                    .navigationDestination(for: Registration.self, destination: { value in
                        PresentInfoEditView(info: value)
                            .environmentObject(viewModel)
                    })
                }//vstack
                // MARK: - background
                .background(
                    LinearGradient(
                        colors: [Color.customBackgroundColor1, Color.customBackgroundColor2],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                )
                //MARK: - navigationbar
                .toolbar {
                    // right
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack {
                            Button(action: {
                                if currentSystemImage == "rectangle.grid.1x2" {
                                    currentSystemImage = "square.grid.3x3"
                                } else {
                                    currentSystemImage = "rectangle.grid.1x2"
                                }

                            }, label: {
                                Image(systemName: currentSystemImage)
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(.black)
                            })
                            Button(action: {

                            }, label: {
                                Image(systemName: "bell")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(.black)

                            })
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.4)) {
                                    isMenuOpen.toggle()
                                }
                            }, label: {
                                Image(systemName: "ellipsis.circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(.black)
                            })
                        }
                    }
                    // left
                    ToolbarItem(placement: .topBarLeading) {
                        Image("logo_transparent")
                            .resizable()
                            .frame(width: 90, height: 90)
                    }
                }//toolbar
            }//navigationstack
            .tint(.black)
            //MARK: - MenuArea
            MenuView(isOpen: $isMenuOpen)
        }//zstack
        .onAppear {
            Task {
                try await viewModel.fetchRegistrationsData()
            }
        }
    } // body
} // MainView

#Preview {
    MainView(user: User.MOCK_USERS[0])
}
