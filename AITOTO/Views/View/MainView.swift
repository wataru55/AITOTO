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
                ZStack {
                    //background
                    LinearGradient(
                        colors: [Color.customBackgroundColor1, Color.customBackgroundColor2],
                            startPoint: .top,
                            endPoint: .bottom
                    )
                    .ignoresSafeArea()

                    VStack {
                        HStack {
                            Text("返礼品を探す")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.black)

                            Spacer()
                        }
                        .frame(width: _width, height: 20)
                        .padding(.top, 30)

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

                        HStack {
                            Text("おもいで記録")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.black)

                            Spacer()
                        }
                        .frame(width: _width, height: 20)

                        NavigationLink(destination: PresentRegistrationView().environmentObject(viewModel)) {
                            Image(systemName: "plus")
                                .foregroundStyle(.black)
                                .frame(width: _width, height: 55)
                                .overlay(.black, in: RoundedRectangle(cornerRadius: 12).stroke(style: .init(lineWidth: 2, dash: [2, 4])))
                        }

                        ScrollView(.vertical, showsIndicators: false) {
                            if currentSystemImage == "rectangle.grid.1x2" {
                                LazyVStack {
                                    ForEach(viewModel.RegistrationItem, id: \.self) { item in
                                        NavigationLink(value: item) {
                                            ListRegistrationItemView(registration: item)
                                        }
                                    }
                                }
                            } else {
                                LazyVGrid(columns: gridLayout) {
                                    ForEach(viewModel.RegistrationItem, id: \.self) { item in
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
                    .toolbar {
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

                        ToolbarItem(placement: .topBarLeading) {
                            Image("logo_transparent")
                                .resizable()
                                .frame(width: 90, height: 90)
                        }
                    }//toolbar
                }

            }//navigationstack
            .tint(.black)
            MenuView(isOpen: $isMenuOpen)
        }//zstack
        .onAppear {
            Task {
                try await viewModel.fetchRegistrationsData()
            }
        }
    }
}

#Preview {
    MainView(user: User.MOCK_USERS[0])
}
