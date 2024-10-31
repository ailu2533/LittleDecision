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
                TipView(tip, arrowEdge: .top)
            }
        }
        .task(id: trigger) {
            totalWeight = await decision.totalWeight
        }
    }

    var showFooter: Bool {
        if let choices = decision.choices, !choices.isEmpty {
            return true
        }
        return false
    }

    // MARK: Private

    @Environment(GlobalViewModel.self) private var globalViewModel

    @State private var trigger = 0
    @State private var totalWeight = 0
    private let tip = ChoiceTip()
}

extension ChoicesSection {
    private func deleteChoices(at indexSet: IndexSet) {
        globalViewModel.deleteChoices(from: decision, at: indexSet)
        trigger += 1
    }
}
