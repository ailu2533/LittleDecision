//
//  WeightInfoSection.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/9.
//

import LemonViews
import SwiftUI

struct WeightInfoSection: View {
    // MARK: Internal

    let choice: Choice

    var body: some View {
        Section {
            LabeledContent {
                Text(totalWeight, format: .number)
            } label: {
                Text("总权重")
            }

            LabeledContent {
                Text(
                    probability(choice.weight, totalWeight),
                    format: .percent.precision(.fractionLength(0 ... 2))
                )
            } label: {
                Text("概率")
            }
        }
        .task(id: choice.weight) {
            totalWeight = await choice.decision?.totalWeight ?? 0
        }
    }

    // MARK: Private

    @State private var totalWeight: Int = 0
}
