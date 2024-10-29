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
    @Default(.decisionID) private var decisionID

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
                    
                    DecisionContentView(decision: currentDecision, selectedChoice: $selectedChoice)
                        .frame(maxHeight: .infinity)
                    
                case .stackedCards:

                    DeckHelperView(currentDecision: currentDecision)
                }
            }

            Spacer()
        }
        .onChange(of: decisionID) { _, _ in
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
    // MARK: Internal

    var currentDecision: Decision

    var choices: [CardChoiceItem] {
        _ = currentDecision.wheelVersion
        _ = equalWeight

        guard let choices = currentDecision.choices else { return [] }

        return choices.map { CardChoiceItem(content: $0.title, weight: $0.weight4calc) }
    }

    var body: some View {
        DeckView(choices: choices, noRepeat: noRepeat)
    }

    // MARK: Private

    @Default(.equalWeight) private var equalWeight
    @Default(.noRepeat) private var noRepeat
}
