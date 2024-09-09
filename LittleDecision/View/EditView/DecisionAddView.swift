//
//  ChoiceAddView.swift
//  LittleDecision
//
//  Created by ailu on 2024/6/8.
//

import SwiftUI
import SwiftUIX

struct DecisionAddView: View {
    @Environment(\.modelContext)
    private var modelContext

    @Binding var showSheet: Bool

//    @Environment(\.dismiss)
//    private var dismiss

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
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        decision.saved = true
//                        dismiss()
                        showSheet = false
                    }, label: {
                        Text("完成")
                    })
                }
            }).onAppearOnce {
                decision.title = template.title
                decision.choices = template.choices.map({ choice in
                    Choice(content: choice)
                })

                modelContext.insert(decision)
            }.onDisappear(perform: {
                if decision.saved == false {
                    modelContext.delete(decision)
                    Logging.shared.debug("delete not saved ")
                }
            })
    }
}
