//
//  RestoreButton.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/15.
//

import LemonViews
import SwiftUI

struct RestoreButton: View {
    let action: () -> Void
    @Binding var tapCount: Int

    var body: some View {
        Button(action: {
            action()
            tapCount += 1
        }) {
            Label("还原", systemImage: "arrow.clockwise")
        }
        .buttonStyle(FloatingButtonStyle())
        .animation(.spring(), value: tapCount)
    }
}

#Preview {
    RestoreButton(action: {
    }, tapCount: .constant(2))
}
