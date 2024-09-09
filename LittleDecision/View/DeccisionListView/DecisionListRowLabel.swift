//
//  DecisionListRowLabel.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/9.
//

import SwiftUI


struct DecisionListRowLabel: View {
    let decision: Decision

    var body: some View {
        VStack(alignment: .leading) {
            Text(decision.title)
                .font(.headline)
                .foregroundStyle(.netureBlack)
            Text("\(decision.choices.count)个选项")
                .foregroundStyle(.secondary)
                .font(.caption)
        }
    }
}
