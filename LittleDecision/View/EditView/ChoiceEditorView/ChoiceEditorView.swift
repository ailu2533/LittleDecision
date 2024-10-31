//
//  ChoiceEditorView.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/15.
//

import LemonViews
import SwiftUI

struct ChoiceEditorView: View {
    // MARK: Lifecycle

    init(choice: Choice) {
        self.choice = choice
    }

    // MARK: Internal

    @Bindable var choice: Choice

    var body: some View {
        LemonForm {
            ChoiceDetailsSection(choice: choice)
            WeightInfoSection(choice: choice)

//            Button(action: {
//                globalViewModel.saveChoice(choice)
//                dismiss()
//            }, label: {
//                Text("保存")
//            })
//            .buttonStyle(FullWidthButtonStyle())
//            .listRowInsets(EdgeInsets())
//            .listRowBackground(Color.clear)
        }
        .mainBackground()
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button(role: .destructive) {
                    globalViewModel.deleteChoice(choice)
                    dismiss()

                } label: {
                    Text("删除")
                }
            }
        }
        .task(id: choice.weight) {
            guard let decision = choice.decision else {
                totalWeight = 0
                return
            }

            totalWeight = await decision.totalWeight
        }
    }

    // MARK: Private

    @Environment(GlobalViewModel.self) private var globalViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var totalWeight: Int = 0
}
