//
//  ChoiceAddView.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/15.
//

import LemonViews
import SwiftUI

// MARK: - ChoiceAddView

struct ChoiceAddView: View {
    // MARK: Lifecycle

    init(decision: Decision) {
        self.decision = decision
    }

    // MARK: Internal

    var body: some View {
        Form {
            choiceDetailsSection
            weightInfoSection
            addMoreSection
        }
//        .mainBackground()
        .task {
            totalWeight = await decision.totalWeight
        }
    }

    // MARK: Private

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var weight: Int = 1

    private let decision: Decision
    private let weightRange = 1 ... 100

    @State private var totalWeight = 0

    @Environment(GlobalViewModel.self) private var globalViewModel

    private var choiceDetailsSection: some View {
        Section {
            ChoiceTitleView(title: $title)
            ChoiceWeightView(weight: $weight)
        }
    }

    private var weightInfoSection: some View {
        Section {
            LabeledContent {
                Text(totalWeight + weight, format: .number)
            } label: {
                Text("总权重")
            }

            LabeledContent {
                Text(probability(weight, totalWeight + weight), format: .percent.precision(.fractionLength(0 ... 2)))
            } label: {
                Text("概率")
            }
        }
    }

    @ViewBuilder
    private var addMoreSection: some View {
        Section {
            HStack {
                Button(action: {
                    saveAndDismiss()
                }, label: {
                    Text("保存")
                })
                .buttonStyle(FullWidthButtonStyle())

                Button(action: {
                    addNewChoice()
                }, label: {
                    Text("继续添加")
                })
                .buttonStyle(FullWidthButtonStyle())
            }
        }
        .listRowBackground(Color.clear)
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
    }

    private func addNewChoice() {
        globalViewModel.addChoice(for: decision, title: title, weight: weight)
        resetForm()
    }

    private func saveAndDismiss() {
        globalViewModel.addChoice(for: decision, title: title, weight: weight)
        dismiss()
    }

    private func resetForm() {
        title = ""
        weight = 1
    }
}

// MARK: - ChoiceAddView2

struct ChoiceAddView2: View {
    // MARK: Lifecycle

    init(decision: TemporaryDecision) {
        self.decision = decision
    }

    // MARK: Internal

    var decision: TemporaryDecision

    var body: some View {
        Form {
            choiceDetailsSection
            weightInfoSection
            addMoreSection
        }
//        .mainBackground()
    }

    // MARK: Private

    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var weight: Int = 1

    private let weightRange = 1 ... 100

    @State private var totalWeight = 0

    private var choiceDetailsSection: some View {
        Section {
            ChoiceTitleView(title: $title)
            ChoiceWeightView(weight: $weight)
        }
    }

    private var weightInfoSection: some View {
        Section {
            LabeledContent {
                Text(decision.totalWeight + weight, format: .number)
            } label: {
                Text("总权重")
            }

            LabeledContent {
                Text(
                    probability(weight, decision.totalWeight + weight),
                    format: .percent.precision(.fractionLength(0 ... 2))
                )
            } label: {
                Text("概率")
            }
        }
    }

    @ViewBuilder
    private var addMoreSection: some View {
        Section {
            HStack {
                Button(action: {
                    saveAndDismiss()
                }, label: {
                    Text("保存")
                })
                .buttonStyle(FullWidthButtonStyle())

                Button(action: {
                    addNewChoice()
                }, label: {
                    Text("继续添加")
                })
                .buttonStyle(FullWidthButtonStyle())
            }
        }
        .listRowBackground(Color.clear)
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
    }

    private func addNewChoice() {
        decision.choices.append(TemporaryChoice(title: title, weight: weight))
        decision.totalWeight = decision.choices.map(\.weight).reduce(.zero, +)
        resetForm()
    }

    private func saveAndDismiss() {
        decision.choices.append(TemporaryChoice(title: title, weight: weight))
        decision.totalWeight = decision.choices.map(\.weight).reduce(.zero, +)
        dismiss()
    }

    private func resetForm() {
        title = ""
        weight = 1
    }
}
