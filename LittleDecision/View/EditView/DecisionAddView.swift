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
            .onAppearOnce {
                postInitDecision()
            }
            .interactiveDismissDisabled(true)
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
    // MARK: Internal

    var decision: TemporaryDecision
    @Binding var showSheet: Bool
    @Binding var showingConfirmation: Bool

    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: {
                let decisionModel = Decision(title: decision.title, choices: [], saved: true)

                modelContext.insert(decisionModel)

                for temporaryChoice in decision.choices {
                    let choice = Choice(content: temporaryChoice.title, weight: temporaryChoice.weight)
                    decisionModel.choices?.append(choice)
                }

                do {
                    try modelContext.save()

                } catch {
                    Logging.shared.error("save error: \(error)")
                }

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
                    showSheet = false
                }
                Button("继续编辑", role: .cancel) {}
            } message: {
                Text("未保存的更改将会丢失")
            }
        }
    }

    // MARK: Private

    @Environment(\.modelContext) private var modelContext
}

// MARK: - CommonAddView

/// 主视图，用于编辑决策和其选项。
struct CommonAddView: View {
    @Bindable var decision: TemporaryDecision

    var body: some View {
        Form {
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
//        .mainBackground()
    }
}

// MARK: - BulkAddChoiceView

struct BulkAddChoiceView: View {
    @State private var bulkText: String = ""
    @Environment(\.dismiss) private var dismiss
    var decision: TemporaryDecision

    @FocusState private var focused

    var body: some View {
        Form {
            TextField("选项", text: $bulkText, prompt: Text("每行一个选项"), axis: .vertical)
                .focused($focused)
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        HStack {
                            Spacer()
                            Button(action: { focused = false }) {
                                Label("收起键盘", systemImage: "keyboard.chevron.compact.down")
                            }
                        }
                    }
                }
        }
        .navigationTitle("批量添加选项")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("取消") {
                    dismiss()
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button("添加") {
                    addBulkChoices()
                    dismiss()
                }
                .disabled(bulkText.isEmpty)
            }
        }
        .onAppearOnce {
            focused = true
        }
    }

    private func addBulkChoices() {
        let lines = bulkText.components(separatedBy: .newlines)
        let validLines = lines
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        for line in validLines {
            decision.choices.append(TemporaryChoice(title: line))
        }

        decision.updateTotalWeight()
    }
}
