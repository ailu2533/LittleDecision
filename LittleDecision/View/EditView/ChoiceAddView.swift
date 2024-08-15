//
//  ChoiceAddView2.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/15.
//

import SwiftUI

struct ChoiceAddView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var weight: Int = 1

    private let decision: Decision
    private let weightRange = 1 ... 100

    init(decision: Decision) {
        self.decision = decision
    }

    var body: some View {
        NavigationStack {
            Form {
                choiceDetailsSection
                weightInfoSection
                addMoreSection
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("保存", action: saveAndDismiss)
                }
            }
        }
    }

    private var choiceDetailsSection: some View {
        Section {
            LabeledContent("选项名") {
                TextField("选项名", text: $title)
                    .multilineTextAlignment(.trailing)
            }
            Picker("权重", selection: $weight) {
                ForEach(weightRange, id: \.self) { Text("\($0)") }
            }
        }
    }

    private var weightInfoSection: some View {
        Section {
            LabeledContent("总权重", value: "\(decision.totalWeight + weight)")
            LabeledContent("当前选项概率", value: probability(weight, decision.totalWeight + weight))
        }
    }

    private var addMoreSection: some View {
        Section {
            Button("继续增加新选项", action: addNewChoice)
        }
    }

    private func addNewChoice() {
        saveChoice()
        resetForm()
    }

    private func saveAndDismiss() {
        saveChoice()
        dismiss()
    }

    private func saveChoice() {
        do {
            let choice = Choice(content: title, weight: weight)
            decision.choices.append(choice)
            try modelContext.save()
        } catch {
            Logging.shared.error("\(error)")
        }
    }

    private func resetForm() {
        title = ""
        weight = 1
    }
}
