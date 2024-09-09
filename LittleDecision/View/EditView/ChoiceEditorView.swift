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
        Form {
            choiceDetailsSection
            weightInfoSection
            deleteSection
        }
        .scrollContentBackground(.hidden)
        .mainBackground()
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button(action: {
                    saveAndDismiss()
                }, label: {
                    Text("保存")
                })
            }
        }
    }
    
    @FocusState private var focused

    private var choiceDetailsSection: some View {
        Section {
            TextField("选项名", text: $choice.title, axis: .vertical)
                .lineLimit(3)
                .fontWeight(.semibold)
                .font(.title3)
                .focused($focused)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        HStack {
                            Spacer()
                            Button(action: {
                                focused = false
                            }, label: {
                                Label("收起键盘", systemImage: "keyboard.chevron.compact.down")
                            })
                        }
                    }
                }
            
            Picker("权重", selection: $choice.weight) {
                ForEach(1 ... 100, id: \.self) { Text("\($0)") }
            }
        }
        .listRowSeparator(.hidden)
    }

    private var weightInfoSection: some View {
        Section {
            LabeledContent("总权重", value: "\(totalWeight)")
            LabeledContent("当前选项概率", value: probability(choice.weight, totalWeight))
        }
        .listRowSeparator(.hidden)
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
            choice.decision?.updateDate = Date()
            try modelContext.save()
            dismiss()
        } catch {
            Logging.shared.error("\(error)")
        }
    }
}
