//
//  FirstView.swift
//  LittleDecision
//
//  Created by ailu on 2024/6/8.
//

import Defaults
import SwiftData
import SwiftUI

struct DecisionContentView: View {
    // MARK: Lifecycle

    init(decision: Decision, selectedChoice: Binding<Choice?>) {
        self.decision = decision
        _selectedChoice = selectedChoice
    }

    // MARK: Internal

    let decision: Decision
    @Binding var selectedChoice: Choice?

    var body: some View {
        VStack {
            PieChartView(selection: $selectedChoice, currentDecision: decision)
                .padding(.horizontal, 12)

            if let choices = decision.choices, choices.isEmpty {
                Text("还没有选项哦，试着添加一些吧")
                    .fontWeight(.bold)
                    .padding(.bottom)
            }
        }
    }
}
