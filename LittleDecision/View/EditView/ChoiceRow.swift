//
//  ChoiceRow.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/14.
//

import LemonViews
import SwiftUI

/// 表示单个选项的视图。
struct ChoiceRow: View {
    let choice: Choice
    let totalWeight: Int

    init(choice: Choice, totalWeight: Int) {
        self.choice = choice
        self.totalWeight = totalWeight
    }

    var body: some View {
        HStack(spacing: 10) {
            SettingIconView(icon: .system(icon: "tag.fill", foregroundColor: .choiceOrange, backgroundColor: .white))

            Text(choice.title)
                .lineLimit(3)

            Spacer()

            Text(probability(choice.weight, totalWeight))
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
