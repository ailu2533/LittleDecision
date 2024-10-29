//
//  ChoicesSection.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/9.
//

import SwiftUI
import TipKit

struct ChoicesSection: View {
    // MARK: Lifecycle

    init(decision: Decision) {
        self.decision = decision
    }

    // MARK: Internal

    var decision: Decision

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

            if let choices = decision.choices, !choices.isEmpty {
                tipView
            }
        }
        .onAppear {
            totalWeight = decision.totalWeight
        }
    }

    func deleteChoices(from decision: Decision, at offsets: IndexSet) {
        let choicesToDelete = offsets.map { decision.sortedChoices[$0] }
        choicesToDelete.forEach { modelContext.delete($0) }
        decision.choices?.removeAll { choice in
            choicesToDelete.contains { $0.uuid == choice.uuid }
        }
    }

    // MARK: Private

    @Environment(\.modelContext) private var modelContext

    @State private var totalWeight = 0
    private let tip = ChoiceTip()

    private var tipView: some View {
        TipView(tip, arrowEdge: .top)
            .tipBackground(Color.clear)
            .listRowBackground(Color.accentColor.opacity(0.1))
            .listSectionSpacing(0)
            .listRowSpacing(0)
    }

    private func deleteChoices(at indexSet: IndexSet) {
        deleteChoices(from: decision, at: indexSet)
        totalWeight = decision.totalWeight
    }
}
