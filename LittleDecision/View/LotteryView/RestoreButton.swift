//
//  RestoreButton.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/15.
//

import SwiftUI

struct RestoreButton: View {
    let action: () -> Void
    @Binding var tapCount: Int

    var body: some View {
        Button(action: {
            action()
            tapCount += 1
        }) {
            Label("还原转盘", systemImage: "arrow.clockwise")
        }
        .buttonStyle(RestoreButtonStyle())
        .animation(.spring(), value: tapCount)
    }
}

struct RestoreButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .font(customBodyFont)
            .fontWeight(.semibold)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.biege)
            .clipShape(Capsule())
            .foregroundColor(.accentColor)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .shadow(radius: 0.5, x: 0.5, y: 0.5)
            .contentShape(Rectangle())
    }
}
