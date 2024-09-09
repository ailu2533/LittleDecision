//
//  PremiumIcon.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/1.
//

import SwiftUI

struct PremiumIcon: View {
    var body: some View {
        Image(systemName: "crown.fill")
            .foregroundStyle(.yellow)
            .font(.headline)
    }
}

#Preview {
    VStack {
        PremiumIcon()
        Image(systemName: "checkmark.circle.fill")
            .foregroundStyle(.green)
            .font(.headline)
    }
}
