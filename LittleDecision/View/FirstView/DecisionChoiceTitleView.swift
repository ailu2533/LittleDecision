//
//  DecisionChoiceTitleView.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/10.
//

import SwiftUI

struct MainViewChoiceTitleView: View {
    var selectedChoice: ChoiceItem?

    var body: some View {
        VStack(spacing: 12) {
            Text(selectedChoice?.content ?? "")
                .font(customSubtitleFont)
                .minimumScaleFactor(0.5)
                .foregroundStyle(.secondary)

                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
        }

        .padding(.horizontal)
    }
}
