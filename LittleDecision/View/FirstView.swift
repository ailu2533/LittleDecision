//
//  FirstView.swift
//  LittleDecision
//
//  Created by ailu on 2024/6/8.
//

import Defaults
import SwiftData
import SwiftUI

struct DecisionTitleView: View {
    var currentDecisionTitle: String?
    var selectedChoiceTitle: String?

    var body: some View {
        VStack(spacing: 12) {
            Text(currentDecisionTitle ?? String(localized: "没有决定"))
                .font(.title)
                .fontWeight(.semibold)
                .fontDesign(.rounded)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .frame(maxWidth: .infinity)

            Group {
                if let selectedChoiceTitle {
                    Text(selectedChoiceTitle)
                } else {
                    Text("")
                }
            }
            .font(.title2)
            .minimumScaleFactor(0.2)
            .fontWeight(.semibold)
            .fontDesign(.rounded)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
        }

        .padding(.horizontal)
    }
}

struct FirstView: View {
    @Default(.decisionId) private var decisionId
    @Environment(\.modelContext) private var modelContext
//    @Environment(DecisionViewModel.self) private var vm
    @State private var selectedChoice: Choice?


    var body: some View {
        VStack {
            Spacer()
            decisionTitleView
            Spacer()
            mainContentView
            Spacer()
        }
        .background {
            Image(uiImage: UIImage(resource: .backgroundImg))
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
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
