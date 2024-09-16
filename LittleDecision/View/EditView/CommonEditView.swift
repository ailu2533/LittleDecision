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

    var body: some View {
        LemonForm {
            EditDecisionTitleView(title: $decision.title)

            DecisionDisplayModePickerView(decision: decision)

            ChoicesSection(decision: decision)
        }
        .contentMargins(16, for: .scrollContent)
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 12) {
                AddChoiceButton(decision: decision)
//                BatchAddChoiceButton(decision: decision)
            }.padding(.trailing, 16)
                .padding(.bottom, 16)
        }
//        .ignoresSafeArea(.keyboard)
        .mainBackground()
    }
}

struct DecisionDisplayModePickerView: View {
    var decision: Decision

    var body: some View {
        HStack {
            SettingIconView(icon: .system(icon: "slider.horizontal.3", foregroundColor: .systemBackground, backgroundColor: .accent))
            Picker("显示模式", selection: Binding(
                get: { decision.displayModeEnum },
                set: {
                    decision.displayModel = $0.rawValue
                    decision.save()
                }
            )) {
                ForEach(DecisionDisplayMode.allCases, id: \.self) { mode in
                    Text(mode.text).tag(mode)
                }
            }
        }
    }
}
