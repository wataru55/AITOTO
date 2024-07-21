//
//  IGTextFieldModifier.swift
//  AITOTO
//
//  Created by  髙橋和 on 2024/07/21.
//

import SwiftUI

struct IGTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
    }
}
