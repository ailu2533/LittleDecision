//
//  ChoicesSection.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/9.
//

import SwiftUI
import TipKit

// MARK: - ChoicesSection

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
        }
        .task {
            totalWeight = decision.totalWeight
        }

        if let choices = decision.choices, !choices.isEmpty {
            TipView(tip, arrowEdge: .top)
                .listRowInsets(EdgeInsets())
                .tipBackground(Color.clear)
        }
    }

    // MARK: Private

    @Environment(GlobalViewModel.self) private var globalViewModel

    @State private var totalWeight = 0
    private let tip = ChoiceTip()
}

extension ChoicesSection {
    private func deleteChoices(at indexSet: IndexSet) {
        globalViewModel.deleteChoices(from: decision, at: indexSet)
        totalWeight = decision.totalWeight
    }
}

// MARK: - ChoicesSection2

struct ChoicesSection2: View {
    // MARK: Lifecycle

    init(decision: TemporaryDecision) {
        self.decision = decision
    }

    // MARK: Internal

    var decision: TemporaryDecision

    var body: some View {
        Section {
            ForEach(decision.choices) { choice in
                NavigationLink {
                    ChoiceEditorView2(decision: decision, choice: choice)
                } label: {
                    ChoiceRow2(choice: choice, totalWeight: decision.totalWeight)
                }
//                .buttonStyle(.plain)
            }
            .onDelete(perform: deleteChoices)

            NavigationLink {
                BulkAddChoiceView(decision: decision)
            } label: {
                Text("批量新增选项")
            }

//            if let choices = decision.choices, !choices.isEmpty {
//                TipView(tip, arrowEdge: .top)
//            }
        }
    }

    // MARK: Private

//    @Environment(GlobalViewModel.self) private var globalViewModel

//    @State private var trigger = 0
//    @State private var totalWeight = 0
//    private let tip = ChoiceTip()

    private func deleteChoices(at indexSet: IndexSet) {
        decision.choices.remove(atOffsets: indexSet)
        decision.totalWeight = decision.choices.map(\.weight).reduce(.zero, +)
    }

//    var showFooter: Bool {
//        if let choices = decision.choices, !choices.isEmpty {
//            return true
//        }
//        return false
//    }
}
