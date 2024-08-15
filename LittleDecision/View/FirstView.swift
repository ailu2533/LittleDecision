//
//  FirstView.swift
//  LittleDecision
//
//  Created by ailu on 2024/6/8.
//

import Defaults
import SwiftData
import SwiftUI

struct FirstView: View {
    @Default(.decisionId) private var decisionId
    @Environment(\.modelContext) private var modelContext
    @Environment(DecisionViewModel.self) private var vm
    @State private var selectedChoice: Choice?

    var body: some View {
        VStack {
            Spacer()
            decisionTitleView
            Spacer()
            mainContentView
            Spacer()
        }
    }

    private var decisionTitleView: some View {
        VStack {
            Text(currentDecision?.title ?? "没有决定")
                .font(.title)
                .fontWeight(.bold)
            Text(selectedChoice?.title ?? "??")
                .font(.title2)
                .foregroundStyle(.red)
        }
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
            PieChartNoRepeatView(selection: $selectedChoice, currentDecision: decision)
                .padding(.horizontal, 12)

            if decision.choices.isEmpty {
                Text("还没有选项哦，试着添加一些吧")
                    .foregroundStyle(Color.secondary)
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
