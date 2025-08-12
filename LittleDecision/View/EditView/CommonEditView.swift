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
    // MARK: Internal

    @Bindable var decision: Decision

    var body: some View {
        Form {
            Section {
                EditDecisionTitleView(title: $decision.title)
                DecisionDisplayModePickerView(decsionBinding: decisionBinding)
            }

            ChoicesSection(decision: decision)
        }
        .safeAreaInset(edge: .bottom) {
            AddChoiceButton(decision: decision)
                .padding(16)
        }
    }

    // MARK: Private

    @Environment(GlobalViewModel.self) private var globalViewModel

    private var decisionBinding: Binding<DecisionDisplayMode> {
        Binding {
            decision.displayModeEnum
        } set: {
            decision.displayModel = $0.rawValue
            decision.save()
            globalViewModel.restore()
        }
    }
}

// MARK: - DecisionDisplayModePickerView

struct DecisionDisplayModePickerView: View {
    @Binding var decsionBinding: DecisionDisplayMode

    var body: some View {
        Picker(selection: $decsionBinding) {
            ForEach(DecisionDisplayMode.allCases) { mode in
                Text(mode.text).tag(mode)
            }
        } label: {
            Text("显示模式")
        }
    }
}
