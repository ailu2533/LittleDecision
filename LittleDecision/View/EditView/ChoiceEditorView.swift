//
//  ChoiceEditorView.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/15.
//

import SwiftUI

struct ChoiceEditorView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Bindable var choice: Choice
    var totalWeight: Int

    init(choice: Choice, totalWeight: Int) {
        self.choice = choice
        self.totalWeight = totalWeight
    }

    var body: some View {
        NavigationStack {
            Form {
                choiceDetailsSection
                weightInfoSection
                deleteSection
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
                TextField("选项名", text: $choice.title)
                    .multilineTextAlignment(.trailing)
            }
            Picker("权重", selection: $choice.weight) {
                ForEach(1 ... 100, id: \.self) { Text("\($0)") }
            }
        }
    }

    private var weightInfoSection: some View {
        Section {
            LabeledContent("总权重", value: "\(totalWeight)")
            LabeledContent("当前选项概率", value: probability(choice.weight, totalWeight))
        }
    }

    private var deleteSection: some View {
        Section {
            Button("删除当前选项", role: .destructive, action: deleteChoice)
        }
    }

    private func deleteChoice() {
        modelContext.delete(choice)
        choice.decision?.choices.removeAll { $0.uuid == choice.uuid }
        saveAndDismiss()
    }

    private func saveAndDismiss() {
        do {
            try modelContext.save()
            dismiss()
        } catch {
            Logging.shared.error("\(error)")
        }
    }
}
