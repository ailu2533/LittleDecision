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
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(.biege)
                .clipShape(Capsule())
        }
        .foregroundColor(.accentColor)
        .buttonStyle(PlainButtonStyle())
        .shadow(radius: 0.8)
        .animation(.spring(), value: tapCount)
    }
}
