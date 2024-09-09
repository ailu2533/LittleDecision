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

    @Environment(\.modelContext)
    private var modelContext

    @Environment(\.dismiss)
    private var dismiss

    let tip = UseDecisionTip()

    @Default(.decisionId) private var decisionId

    var body: some View {
        LemonList {
            ForEach(savedDecisions) { decision in
                HStack {
                    Button(action: {
                        decisionId = decision.uuid
                        dismiss()
                    }, label: {
                        Image(systemName: decisionId == decision.uuid ? "checkmark.circle.fill" : "circle")
                            .imageScale(.large)
                            .fontWeight(.semibold)
                            .foregroundColor(.accentColor)
                    })
                    .buttonStyle(PlainButtonStyle())

                    NavigationLink(destination: DecisionEditorView(decision: decision)) {
                        DecisionListRowLabel(decision: decision)
                    }
                }
                .swipeActions {
                    DeleteDecisionButton(decision: decision)
                }
            }
            TipView(tip, arrowEdge: .top)
                .listRowBackground(Color.accentColor.opacity(0.1))
                .tipBackground(Color.clear)
                .listRowSpacing(0)
        }
    }
}
