//
//  CommonEditView.swift
//  LittleDecision
//
//  Created by ailu on 2024/6/8.
//

import LemonViews
import SwiftUI

/// 主视图，用于编辑决策和其选项。
struct CommonEditView: View {
    @Bindable var decision: Decision
    @Environment(DecisionViewModel.self) private var viewModel

    private let tip = ChoiceTip()

    var body: some View {
        Form {
            EditDecisionTitleView(title: $decision.title)

            HStack {
                SettingIconView(icon: .system(icon: "slider.horizontal.3", foregroundColor: .white, backgroundColor: .accent))
                Picker("显示模式", selection: Binding(
                    get: { DecisionDisplayMode(rawValue: decision.displayModel) ?? .wheel },
                    set: { decision.displayModel = $0.rawValue }
                )) {
                    ForEach(DecisionDisplayMode.allCases, id: \.self) { mode in
                        Text(mode.text).tag(mode)
                    }
                }
            }

            ChoicesSection(decision: decision)
        }
        .contentMargins(16, for: .scrollContent)
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 12) {
                AddChoiceButton(decision: decision)
                BatchAddChoiceButton(decision: decision)
            }.padding(.trailing, 16)
        }
        .ignoresSafeArea(.keyboard)
        .scrollContentBackground(.hidden)
        .mainBackground()
    }
}

