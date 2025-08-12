//
//  ChoiceRow.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/14.
//

import LemonViews
import SwiftUI

// MARK: - ChoiceRow

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
            LabeledContent {
                Text(probability(choice.weight, totalWeight), format: .percent.precision(.fractionLength(0 ... 2)))
            } label: {
                Text(choice.title)
                    .lineLimit(3)
            }
        }
    }
}

// MARK: - ChoiceRow2

struct ChoiceRow2: View {
    // MARK: Lifecycle

    init(choice: TemporaryChoice, totalWeight: Int) {
        self.choice = choice
        self.totalWeight = totalWeight
    }

    // MARK: Internal

    let choice: TemporaryChoice
    let totalWeight: Int

    var body: some View {
        HStack(spacing: 10) {
            LabeledContent {
                Text(
                    probability(choice.weight, totalWeight),
                    format: .percent.precision(.fractionLength(0 ... 2))
                )
            } label: {
                Text(choice.title)
                    .lineLimit(3)
            }
        }
    }
}
