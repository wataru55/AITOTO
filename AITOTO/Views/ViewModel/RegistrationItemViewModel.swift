//
//  RegistrationItemViewModel.swift
//  AITOTO
//
//  Created by  髙橋和 on 2024/08/09.
//

import Foundation

class RegistrationItemViewModel: ObservableObject {
    @Published var RegistrationItem = [Registration]()
    let uid: String

    init(uid: String) {
        self.uid = uid
        fetchRegistrationsData()
    }

    func fetchRegistrationsData() {
        Task {
            do {
                let registrationData = try await UserService.fetchRegistrationsDocuments(withUid: uid)

                await MainActor.run() {
                    self.RegistrationItem = registrationData
                }

            } catch {
                print("Error fetching connected users: \(error)")
            }
        }
    }
}
