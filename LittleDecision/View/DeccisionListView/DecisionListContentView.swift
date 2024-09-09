//
//  DecisionListContentView.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/9.
//

import SwiftUI
import TipKit

struct DecisionListContentView: View {
    let savedDecisions: [Decision]

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    let tip = UseDecisionTip()

    var body: some View {
        LemonList {
            ForEach(savedDecisions) { decision in
                DecisionRow(decision: decision)
            }
            TipView(tip, arrowEdge: .top)
                .listRowBackground(Color.accentColor.opacity(0.1))
                .tipBackground(Color.clear)
                .listRowSpacing(0)
        }
    }
}
