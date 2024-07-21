//
//  ContentViewModel.swift
//  AITOTO
//
//  Created by  髙橋和 on 2024/07/21.
//

import Foundation
import Firebase
import Combine

class ContentViewModel: ObservableObject {
    private let service = AuthService.shared
    private var cancellables = Set<AnyCancellable>()

    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?

    init() {
        setupSubscribers()
    }

    func setupSubscribers() {
        service.$userSession
            .sink { [ weak self ] userSession in //1.userSessionプロパティが持つPublisherにアクセス, 2.　.sinkでPublisherからデータ(userSession)を受け取る
            self?.userSession = userSession
        }
        .store(in: &cancellables) //作成されたサブスクリプション（購読）を管理

        service.$currentUser
            .sink { [ weak self ] currentUser in //1.userSessionプロパティが持つPublisherにアクセス, 2.　.sinkでPublisherからデータ(userSession)を受け取る
            self?.currentUser = currentUser
        }
        .store(in: &cancellables) //作成されたサブスクリプション（購読）を管理
    }

    func forceSignout() {
        service.signout()
        print("ユーザデータが見つかりませんでした")
    }
}
