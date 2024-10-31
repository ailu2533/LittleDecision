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
    // MARK: Internal

    let decisions: [Decision]

    var body: some View {
        LemonList {
            decisionList
            TipView(tip, arrowEdge: .top)
        }
    }

    // MARK: Private

    @Default(.decisionID) private var decisionID

    @Environment(\.dismiss) private var dismiss

    @Environment(GlobalViewModel.self) private var globalViewModel

    private let tip = UseDecisionTip()

    private var decisionList: some View {
        ForEach(decisions) { decision in
            DecisionRow(
                decision: decision,
                isSelected: decisionID == decision.uuid,
                selectAction: {
                    globalViewModel.selectDecision(decision)
                    dismiss()
                }
            )
            .swipeActions {
                Button(role: .destructive) {
                    globalViewModel.deleteDecision(decision)
                } label: {
                    Label("删除决定", systemImage: "trash.fill")
                }
            }
        }
    }
}
