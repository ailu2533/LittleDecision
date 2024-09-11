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

    @Environment(\.modelContext)
    private var modelContext

    let currentDecision: Decision

    var body: some View {
        VStack {
            Spacer()
            VStack {
                DecisionTitle(decision: currentDecision)
                if currentDecision.displayModeEnum == .wheel {
                    DecisionChoiceTitleView(selectedChoiceTitle: selectedChoice?.title)
                }
            }

            VStack {
                switch currentDecision.displayModeEnum {
                case .wheel:
                    FirstView(currentDecision: currentDecision, selectedChoice: $selectedChoice)
                case .stackedCards:

                    let choices = currentDecision.choices.map { $0.title }
                    DeckView(choices: choices)
                }
            }
            .id(currentDecision.hashValue & equalWeight.hashValue)

            Spacer()
        }
    }

    private var noDecisionView: some View {
        ContentUnavailableView {
            Label("请在决定Tab添加决定", systemImage: "tray.fill")
        }
    }
}
