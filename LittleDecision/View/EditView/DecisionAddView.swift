//
//  ChoiceAddView.swift
//  LittleDecision
//
//  Created by ailu on 2024/6/8.
//

import SwiftUI
import SwiftUIX

// MARK: - DecisionAddView

struct DecisionAddView: View {
    // MARK: Lifecycle

    init(showSheet: Binding<Bool>, template: DecisionTemplate) {
        _showSheet = showSheet
        self.template = template
    }

    // MARK: Internal

    @Binding var showSheet: Bool
    let template: DecisionTemplate

    var body: some View {
        CommonAddView(decision: temporaryDecision)
            .navigationTitle("新增决定")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                DecisionAddViewToolbar(
                    decision: temporaryDecision,
                    showSheet: $showSheet,
                    showingConfirmation: $showingConfirmation
                )
            }
//            .navigationBarBackButtonHidden(true) // 1
            .onAppearOnce {
                postInitDecision()
            }

//            .interactiveDismissDisabled(true)
    }

    // MARK: Private

    @State private var temporaryDecision = TemporaryDecision()
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showingConfirmation = false

//    @State private var decision: Decision = .init(title: "", choices: [])
}

extension DecisionAddView {
    func postInitDecision() {
        temporaryDecision.title = template.title
        temporaryDecision.choices = template.choices.map({ choice in
            TemporaryChoice(title: choice)
        })

//        modelContext.insert(decision)
    }
}

// MARK: - DecisionAddViewToolbar

struct DecisionAddViewToolbar: ToolbarContent {
    var decision: TemporaryDecision
    @Binding var showSheet: Bool
    @Binding var showingConfirmation: Bool

    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: {
//                decision.saved = true

                // TODO:

                showSheet = false
            }, label: {
                Text("保存")
            })
        }
        ToolbarItem(placement: .topBarLeading) {
            Button(action: {
                showingConfirmation = true
            }, label: {
                Text("取消")
            })
            .confirmationDialog("确定要取消吗？", isPresented: $showingConfirmation) {
                Button("确定", role: .destructive) {
//                    modelContext.delete(decision)
//
//                    do {
//                        try modelContext.save()
//                    } catch {
//                        Logging.shared.error("\(error)")
//                    }
//
//                    showSheet = false
                }
                Button("继续编辑", role: .cancel) {}
            } message: {
                Text("未保存的更改将会丢失")
            }
        }
    }
}

// MARK: - CommonAddView

/// 主视图，用于编辑决策和其选项。
struct CommonAddView: View {
    @Bindable var decision: TemporaryDecision

    var body: some View {
        LemonForm {
            Section {
                EditDecisionTitleView(title: $decision.title)

                DecisionDisplayModePickerView2(decsionBinding: $decision.displayMode)
            }

            ChoicesSection2(decision: decision)
        }
        .safeAreaInset(edge: .bottom) {
            AddChoiceButton2(decision: decision)
                .padding(16)
        }
        .mainBackground()
    }
}
