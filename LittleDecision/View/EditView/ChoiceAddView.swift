//
//  ChoiceAddView.swift
//  LittleDecision
//
//  Created by ailu on 2024/6/8.
//

import SwiftUI

struct ChoiceAddView: View {
    @Environment(\.modelContext)
    private var modelContext

    @Environment(\.dismiss)
    private var dismiss

    @State private var decision: Decision = .init(title: "", choices: [])

    init() {}

    var body: some View {
        NavigationStack {
            CommonEditView(decision: decision)
                .navigationTitle("新增决定")
                .toolbar(content: {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            decision.saved = true
                            dismiss()
                        }, label: {
                            Text("完成")
                        })
                    }
                })

        }.onAppear {
            modelContext.insert(decision)
        }.onDisappear(perform: {
            if decision.saved == false {
                modelContext.delete(decision)
                Logging.shared.debug("delete not saved ")
            }
        })
    }
}

#Preview {
    ChoiceAddView()
}
