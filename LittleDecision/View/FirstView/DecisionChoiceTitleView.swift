//
//  DecisionChoiceTitleView.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/10.
//

import SwiftUI

struct DecisionChoiceTitleView: View {
    var selectedChoiceTitle: String?

    var body: some View {
        VStack(spacing: 12) {
            Group {
                if let selectedChoiceTitle {
                    Text(selectedChoiceTitle)
                } else {
                    Text("")
                }
            }

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
