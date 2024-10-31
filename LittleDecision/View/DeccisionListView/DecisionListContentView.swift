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
    @Environment(\.dismiss) private var dismiss
    @Default(.decisionID) private var decisionID

    @Environment(GlobalViewModel.self) private var globalViewModel

    let tip = UseDecisionTip()

    var body: some View {
        LemonList {
            decisionList
            TipView(tip, arrowEdge: .top)
        }
    }

    private var decisionList: some View {
        ForEach(savedDecisions) { decision in
            DecisionRow(
                decision: decision,
                isSelected: decisionID == decision.uuid,
                selectAction: {
                    globalViewModel.selectDecision(decision)
                    dismiss()
                }
            )
            .swipeActions {
                DeleteDecisionButton(decision: decision)
            }
        }
    }
}
