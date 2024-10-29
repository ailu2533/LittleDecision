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
                .foregroundStyle(.primary)
            Text("\(decision.choices?.count ?? 0)个选项")
                .foregroundStyle(.secondary)
                .font(.caption)
        }
    }
}
