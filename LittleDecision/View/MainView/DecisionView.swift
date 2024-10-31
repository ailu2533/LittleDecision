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
    @Binding var selectedChoice: Choice?
    var currentDecision: Decision

    var body: some View {
        let _ = Self._printChanges()

        VStack {
            VStack {
                MainViewDecisionTitle(decision: currentDecision)
//                DecisionChoiceTitleView(selectedChoiceTitle: selectedChoice?.title).opacity(currentDecision.displayModeEnum == .wheel ? 1 : 0)
            }
            .padding(.top, 32)

            switch currentDecision.displayModeEnum {
            case .wheel:
//                DecisionContentView(decision: currentDecision, selectedChoice: $selectedChoice)
//                    .frame(maxHeight: .infinity)
                Text("PieChartView")

            case .stackedCards:
                DeckHelperView(currentDecision: currentDecision)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct DeckHelperView: View {
    // MARK: Internal

    var currentDecision: Decision

    var choices: [ChoiceItem] {
//        _ = currentDecision.wheelVersion
//        _ = equalWeight

        guard let choices = currentDecision.choices else { return [] }

        return choices.map { ChoiceItem(content: $0.title, weight: $0.weight4calc) }
    }

    var body: some View {
        DeckView(choices: choices, noRepeat: noRepeat)
    }

    // MARK: Private

//    @Default(.equalWeight) private var equalWeight
    @Default(.noRepeat) private var noRepeat
}



struct DeckHelperViewRefactor: View {
//
//    var currentDecision: Decision
//
//    var choices: [ChoiceItem] {
//        _ = currentDecision.wheelVersion
    ////        _ = equalWeight
//
//        guard let choices = currentDecision.choices else { return [] }
//
//        return choices.map { ChoiceItem(content: $0.title, weight: $0.weight4calc) }
//    }
//
//    var body: some View {
//        DeckView(choices: choices, noRepeat: noRepeat)
//    }
//
//
    ////    @Default(.equalWeight) private var equalWeight
//    @Default(.noRepeat) private var noRepeat

    var globalViewModel: GlobalViewModel

    var body: some View {
        Text("DeckHelperViewRefactor")
    }
}
