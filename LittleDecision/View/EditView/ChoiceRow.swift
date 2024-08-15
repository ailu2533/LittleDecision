//
//  ChoiceRow.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/14.
//

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
            Image(systemName: "tag.fill")
                .font(.system(.body, design: .rounded))
                .foregroundColor(.accentColor)
                .frame(width: 24, height: 24)

            Text(choice.title)
                .lineLimit(1)

            Spacer()

            Text(probability(choice.weight, totalWeight))
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
