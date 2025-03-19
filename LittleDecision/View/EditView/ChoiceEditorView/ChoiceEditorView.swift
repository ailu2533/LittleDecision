//
//  ChoiceEditorView.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/15.
//

import LemonViews
import SwiftUI

// MARK: - ChoiceEditorView

struct ChoiceEditorView: View {
    // MARK: Lifecycle

    init(choice: Choice) {
        self.choice = choice
    }

    // MARK: Internal

    @Bindable var choice: Choice

    var body: some View {
        Form {
            ChoiceDetailsSection(choice: choice)
            WeightInfoSection(choice: choice)

            Button(action: {
                globalViewModel.saveChoice(choice)
                dismiss()
            }, label: {
                Text("保存")
            })
            .buttonStyle(FullWidthButtonStyle())
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
        }
        .mainBackground()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
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

// MARK: - ChoiceEditorView2

struct ChoiceEditorView2: View {
    // MARK: Internal

    var decision: TemporaryDecision
    @Bindable var choice: TemporaryChoice

    var body: some View {
        Form {
            Section {
                ChoiceTitleView(title: $choice.title)
                ChoiceWeightView(weight: $choice.weight)
            }

            Section {
                LabeledContent {
                    Text(decision.totalWeight, format: .number)
                } label: {
                    Text("总权重")
                }

                LabeledContent {
                    Text(
                        probability(choice.weight, decision.totalWeight),
                        format: .percent.precision(.fractionLength(0 ... 2))
                    )
                } label: {
                    Text("概率")
                }
            }

            Button(action: {
                dismiss()
            }, label: {
                Text("保存")
            })
            .buttonStyle(FullWidthButtonStyle())
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
        }
        .mainBackground()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(role: .destructive) {
                    decision.choices.removeAll {
                        choice == $0
                    }

                    decision.totalWeight = decision.choices.map(\.weight).reduce(.zero, +)

                    dismiss()

                } label: {
                    Text("删除")
                }
            }
        }
    }

    // MARK: Private

//    @Environment(GlobalViewModel.self) private var globalViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var totalWeight: Int = 0
}
