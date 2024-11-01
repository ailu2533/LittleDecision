//
//  DecisionChoiceTitleView.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/10.
//

import SwiftUI

struct MainViewChoiceTitleView: View {
    var selectedChoice: ChoiceItem?

    var choiceTitle: String {
        selectedChoice?.content ?? ""
    }

    var body: some View {
        Text(choiceTitle)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
    }
}
