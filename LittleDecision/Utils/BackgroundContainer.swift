//
//  BackgroundContainer.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/30.
//

import SwiftUI

struct BackgroundViewModifier<Background: View>: ViewModifier {
    let background: Background

    init(@ViewBuilder background: () -> Background) {
        self.background = background()
    }

    func body(content: Content) -> some View {
        content
            .background(background.ignoresSafeArea())
    }
}

extension View {
    func customBackground<Background: View>(@ViewBuilder _ background: @escaping () -> Background) -> some View {
        modifier(BackgroundViewModifier(background: background))
    }

    // 设置页面的背景
    func settingsBackground() -> some View {
        customBackground {
            LinearGradient(colors: [.accent.opacity(0.5), .accent.opacity(0.4), .accent.opacity(0.2)],
                           startPoint: .top,
                           endPoint: .bottom)
        }
    }

    // 主页面的背景
    func mainBackground() -> some View {
        customBackground {
            LinearGradient(colors: [.accent.opacity(0.3), .accent.opacity(0.2), .accent.opacity(0.01)],
                           startPoint: .top,
                           endPoint: .bottom)
        }
    }
}

#Preview {
    List {
        Color.accentColor.opacity(0.3)
            .frame(width: 200, height: 200)

        Color.accentColor.opacity(0.2)
            .frame(width: 200, height: 200)

        Color.accentColor.opacity(0.01)
            .frame(width: 200, height: 200)
    }
}
