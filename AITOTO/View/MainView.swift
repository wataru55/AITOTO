//
//  RootView.swift
//  AITOTO
//
//  Created by  髙橋和 on 2024/07/21.
//

import SwiftUI

struct MainView: View {
    @State var isMenuOpen = false

    let user: User

    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    NavigationLink(destination: PresentRecommendationView()) {
                        Image("ai_present")
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width - 40, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 12.0))
                            .padding(.top, 30)
                            .padding(.bottom, 10)
                    }

                    Divider()

                    ScrollView(.vertical, showsIndicators: false) {
                        NavigationLink(destination: PresentRegistrationView()) {
                            Image(systemName: "plus")
                                .foregroundStyle(.black)
                                .frame(width: 350, height: 100)
                                .overlay(.black, in: RoundedRectangle(cornerRadius: 12).stroke(style: .init(lineWidth: 2, dash: [2, 4])))
                                .padding(.top, 10)
                        }
                    }

                }//vstack
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack {
                            Button(action: {

                            }, label: {
                                Image(systemName: "rectangle.grid.1x2")
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
                        Button(action: {

                        }, label: {
                            Image("logo")
                                .resizable()
                                .frame(width: 100, height: 100)
                        })
                    }
                }
            }//navigationstack
            MenuView(isOpen: $isMenuOpen)
        }//zstack
    }
}

#Preview {
    MainView(user: User.MOCK_USERS[0])
}
