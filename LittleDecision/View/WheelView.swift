//
//  FirstView.swift
//  LittleDecision
//
//  Created by ailu on 2024/6/8.
//

import Defaults
import SwiftData
import SwiftUI

struct WheelView: View {
    @Environment(\.modelContext)
    private var modelContext

    let currentDecision: Decision

    @Binding var selectedChoice: Choice?

    var body: some View {
        let _ = Self._printChanges()

        VStack {
            Spacer()
            decisionContentView(for: currentDecision)
            Spacer()
        }
    }

    private func decisionContentView(for decision: Decision) -> some View {
        VStack {
            PieChartView(selection: $selectedChoice, currentDecision: decision)
                .padding(.horizontal, 12)

            if decision.choices.isEmpty {
                Text("还没有选项哦，试着添加一些吧")
                    .fontWeight(.bold)
                    .padding(.bottom)
            }
        }
    }
}
