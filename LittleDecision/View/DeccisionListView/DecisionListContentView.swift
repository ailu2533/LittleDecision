//
//  DecisionListContentView.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/9.
//

import Defaults
import SwiftUI
import TipKit

struct DecisionListContentView: View {
    let savedDecisions: [Decision]
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Default(.decisionID) private var decisionID

    let tip = UseDecisionTip()

    var body: some View {
        LemonList {
            decisionList
            tipView
        }
    }

    private var decisionList: some View {
        ForEach(savedDecisions) { decision in
            DecisionRow(decision: decision, isSelected: decisionID == decision.uuid, selectAction: { selectDecision(decision) })
                .swipeActions { DeleteDecisionButton(decision: decision) }
        }
    }

    private var tipView: some View {
        TipView(tip, arrowEdge: .top)
            .listRowBackground(Color.accentColor.opacity(0.1))
            .tipBackground(Color.clear)
            .listRowSpacing(0)
    }

    private func selectDecision(_ decision: Decision) {
        decisionID = decision.uuid
        dismiss()
    }
}
