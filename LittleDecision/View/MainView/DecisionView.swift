//
//  DecisionView.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/9.
//

import Defaults
import SwiftData
import SwiftUI

struct DecisionView: View {
    @State private var selectedChoice: Choice?
    @Default(.decisionId) private var decisionId

    @Default(.equalWeight) private var equalWeight
    @Default(.noRepeat) private var noRepeat

    @Environment(\.modelContext)
    private var modelContext

    let currentDecision: Decision

    var body: some View {
        let _ = Self._printChanges()

        VStack {
            Spacer()
            VStack {
                DecisionTitle(decision: currentDecision)
                if currentDecision.displayModeEnum == .wheel {
                    DecisionChoiceTitleView(selectedChoiceTitle: selectedChoice?.title)
                }
            }
            .padding(.top, 32)

            VStack {
                switch currentDecision.displayModeEnum {
                case .wheel:
                    WheelView(currentDecision: currentDecision, selectedChoice: $selectedChoice)
                case .stackedCards:

                    DeckHelperView(currentDecision: currentDecision)
                }
            }

            Spacer()
        }
        .onChange(of: decisionId) { _, _ in
            selectedChoice = nil
        }
    }

    private var noDecisionView: some View {
        ContentUnavailableView {
            Label("请在决定Tab添加决定", systemImage: "tray.fill")
        }
    }
}

struct DeckHelperView: View {
    var currentDecision: Decision

    @Default(.equalWeight) private var equalWeight
    @Default(.noRepeat) private var noRepeat

    var choices: [CardChoiceItem] {
        _ = currentDecision.wheelVersion
        _ = equalWeight

        return currentDecision.choices.map { CardChoiceItem(content: $0.title, weight: $0.weight4calc) }
    }

    var body: some View {
        DeckView(choices: choices, noRepeat: noRepeat)
    }
}
