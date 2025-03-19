//
//  CommonEditView.swift
//  LittleDecision
//
//  Created by ailu on 2024/6/8.
//

import LemonViews
import SwiftUI
import SwiftUIX

// MARK: - CommonEditView

/// 主视图，用于编辑决策和其选项。
struct CommonEditView: View {
    @Bindable var decision: Decision

    var body: some View {
        LemonForm {
            Section {
                EditDecisionTitleView(title: $decision.title)
                DecisionDisplayModePickerView(decision: decision)
            }

            ChoicesSection(decision: decision)
        }
        .safeAreaInset(edge: .bottom) {
            AddChoiceButton(decision: decision)
                .padding(16)
        }
        .mainBackground()
    }
}

// MARK: - DecisionDisplayModePickerView

struct DecisionDisplayModePickerView: View {
    // MARK: Internal

    var decision: Decision

    var body: some View {
        Picker(selection: decsionBinding) {
            ForEach(DecisionDisplayMode.allCases) { mode in
                Text(mode.text).tag(mode)
            }
        } label: {
            Label("显示模式", systemSymbol: .sliderHorizontal3)
        }
        .labelStyle(SettingsLabelStyle(backgroundColor: .accent))
    }

    var decsionBinding: Binding<DecisionDisplayMode> {
        Binding {
            decision.displayModeEnum
        } set: {
            decision.displayModel = $0.rawValue
            decision.save()
            globalViewModel.restore()
        }
    }

    // MARK: Private

    @Environment(GlobalViewModel.self) private var globalViewModel
}
