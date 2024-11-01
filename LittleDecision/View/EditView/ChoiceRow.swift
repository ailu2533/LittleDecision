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
    // MARK: Lifecycle

    init(choice: Choice, totalWeight: Int) {
        self.choice = choice
        self.totalWeight = totalWeight
    }

    // MARK: Internal

    let choice: Choice
    let totalWeight: Int

    var body: some View {
        HStack(spacing: 10) {
            SettingIconView(icon: .system(icon: "tag.fill", foregroundColor: .secondaryAccent, backgroundColor: Color(.systemBackground)))

            Text(choice.title)
                .lineLimit(3)

            Spacer()

            Text(probability(choice.weight, totalWeight))
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
