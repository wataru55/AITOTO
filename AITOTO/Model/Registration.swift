//
//  Registration.swift
//  AITOTO
//
//  Created by  髙橋和 on 2024/08/05.
//

import Foundation
import Firebase

struct Registration: Identifiable, Hashable, Codable {
    let id: String
    let ownerUid: String
    let imageURL: String
    let date: Date
    var title: String
    var bio: String?
}

extension Registration {
    static var MOCK_REGISTRATIONS: [Registration] = [
        .init(id: NSUUID().uuidString, ownerUid: NSUUID().uuidString,imageURL: "logo", date: Date(), title: "大好きなクマちゃん")
    ]
}
