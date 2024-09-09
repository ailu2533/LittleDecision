//
//  DeckModeView.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/6.
//

import DeckKit
import Defaults
import Foundation
import SwiftData
import SwiftUI

struct DeckModeView: View {
    @Default(.decisionId) private var decisionId
    @Environment(\.modelContext) private var modelContext
    @State private var selectedChoice: Choice?

    var items: [Hobby] {
        if let currentDecision {
            return currentDecision.choices.compactMap({ choice in
                Hobby(text: choice.title)
            })
        }
        return []
    }

    var body: some View {
        DeckCardView(items: items)
            .mainBackground()
            .id(decisionId)
    }

    private var decisionTitleView: some View {
        DecisionTitleView(currentDecisionTitle: currentDecision?.title, selectedChoiceTitle: selectedChoice?.title)
    }

    private var mainContentView: some View {
        Group {
            if let currentDecision = currentDecision {
                decisionContentView(for: currentDecision)
            } else {
                noDecisionView
            }
        }
    }

    private func decisionContentView(for decision: Decision) -> some View {
        VStack {
            PieChartView(selection: $selectedChoice, currentDecision: decision)
                .padding(.horizontal, 12)

            if decision.choices.isEmpty {
                Text("还没有选项哦，试着添加一些吧")
                    .fontWeight(.bold)
//                    .foregroundStyle(Color.)
                    .padding(.bottom)
            }
        }
    }

    private var noDecisionView: some View {
        ContentUnavailableView {
            Label("请在决定Tab添加决定", systemImage: "tray.fill")
        }
    }

    private var currentDecision: Decision? {
        let predicate = #Predicate<Decision> { $0.uuid == decisionId }
        let descriptor = FetchDescriptor(predicate: predicate)

        do {
            let res = try modelContext.fetch(descriptor).first
            Logging.shared.debug("currentDecision: \(res.debugDescription)  isNil \(res == nil)")
            return res
        } catch {
            Logging.shared.error("currentDecision: \(error)")
            return nil
        }
    }
}
