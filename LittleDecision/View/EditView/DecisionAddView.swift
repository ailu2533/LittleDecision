//
//  ChoiceAddView.swift
//  LittleDecision
//
//  Created by ailu on 2024/6/8.
//

import SwiftUI
import SwiftUIX

struct DecisionAddView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Binding var showSheet: Bool
    @State private var showingConfirmation = false

    let template: DecisionTemplate

    @State private var decision: Decision = .init(title: "", choices: [])

    init(showSheet: Binding<Bool>, template: DecisionTemplate) {
        _showSheet = showSheet
        self.template = template
    }

    var body: some View {
        CommonEditView(decision: decision)
            .navigationTitle("新增决定")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
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
            .navigationBarBackButtonHidden(true) // 1
            .onAppearOnce {
                decision.title = template.title
                decision.choices = template.choices.map({ choice in
                    Choice(content: choice)
                })

                modelContext.insert(decision)
            }
            .onDisappear {
                do {
                    try modelContext.save()
                } catch {
                    Logging.shared.error("\(error)")
                }
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
}
