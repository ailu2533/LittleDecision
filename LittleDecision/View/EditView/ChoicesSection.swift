//
//  ChoicesSection.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/9.
//

import SwiftUI
import TipKit

struct ChoicesSection: View {
    @Environment(DecisionViewModel.self) private var viewModel

    var decision: Decision

    @State private var totalWeight = 0
    private let tip = ChoiceTip()

    init(decision: Decision) {
        self.decision = decision
    }

    var body: some View {
        Section {
            ForEach(decision.sortedChoices) { choice in
                NavigationLink {
                    ChoiceEditorView(choice: choice)
                } label: {
                    ChoiceRow(choice: choice, totalWeight: totalWeight)
                }
                .buttonStyle(.plain)
            }
            .onDelete(perform: deleteChoices)

            if !decision.choices.isEmpty {
                tipView
            }
        }
        .onAppear {
            totalWeight = decision.totalWeight
        }
    }

    private var tipView: some View {
        TipView(tip, arrowEdge: .top)
            .tipBackground(Color.clear)
            .listRowBackground(Color.accentColor.opacity(0.1))
            .listSectionSpacing(0)
            .listRowSpacing(0)
    }

    private func deleteChoices(at indexSet: IndexSet) {
        viewModel.deleteChoices(from: decision, at: indexSet)
        totalWeight = decision.totalWeight
    }
}
