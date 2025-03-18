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
//            SettingIconView(
//                icon: .system(
//                    icon: .tagFill,
//                    foregroundColor: .secondaryAccent,
//                    backgroundColor: Color(.systemBackground)
//                )
//            )
//
//
//
//            Spacer()

//            Text(probability(choice.weight, totalWeight))
//                .font(.caption)
//                .foregroundColor(.secondary)

            LabeledContent {
                Text(probability(choice.weight, totalWeight), format: .percent.precision(.fractionLength(0 ... 2)))
            } label: {
                Text(choice.title)
                    .lineLimit(3)
            }
        }
    }
}
