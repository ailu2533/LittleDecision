//
//  ChoiceAddView.swift
//  LittleDecision
//
//  Created by ailu on 2024/6/8.
//

import SwiftUI
import SwiftUIX

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
        CommonEditView(decision: decision)
            .navigationTitle("新增决定")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                DecisionAddViewToolbar(decision: decision, showSheet: $showSheet, showingConfirmation: $showingConfirmation)
            }
            .navigationBarBackButtonHidden(true) // 1
            .onAppearOnce {
                postInitDecision()
            }
            .confirmationDialog("确定要取消吗？", isPresented: $showingConfirmation) {
                Button("确定", role: .destructive) {
                    modelContext.delete(decision)

                    do {
                        try modelContext.save()
                    } catch {
                        Logging.shared.error("\(error)")
                    }

                    showSheet = false
                }
                Button("继续编辑", role: .cancel) {}
            } message: {
                Text("未保存的更改将会丢失")
            }
            .interactiveDismissDisabled(true)
    }

    // MARK: Private

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showingConfirmation = false

    @State private var decision: Decision = .init(title: "", choices: [])
}

extension DecisionAddView {
    func postInitDecision() {
        decision.title = template.title
        decision.choices = template.choices.map({ choice in
            Choice(content: choice)
        })

        modelContext.insert(decision)
    }
}

struct DecisionAddViewToolbar: ToolbarContent {
    var decision: Decision
    @Binding var showSheet: Bool
    @Binding var showingConfirmation: Bool

    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: {
                decision.saved = true
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
        }
    }
}
