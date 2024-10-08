//
//  ChoiceEditorView.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/15.
//

import LemonViews
import SwiftUI

struct ChoiceEditorView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Bindable var choice: Choice
    @State private var totalWeight: Int = 0

    init(choice: Choice) {
        self.choice = choice
    }

    var body: some View {
        LemonForm {
            ChoiceDetailsSection(choice: choice)
            WeightInfoSection(choice: choice)

            Button(action: {
                saveAndDismiss()
            }, label: {
                Text("保存")
            })
            .buttonStyle(FullWidthButtonStyle())
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
        }
        .mainBackground()
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button("删除", role: .destructive, action: deleteChoice)
            }
        }
        .task(id: choice.weight) {
            totalWeight = choice.decision?.totalWeight ?? 0
        }
    }

    private func deleteChoice() {
        modelContext.delete(choice)
        choice.decision?.choices.removeAll { $0.uuid == choice.uuid }
        saveAndDismiss()
    }

    private func saveAndDismiss() {
        do {
            choice.decision?.incWheelVersion()
            try modelContext.save()
            dismiss()
        } catch {
            Logging.shared.error("\(error)")
        }
    }
}

struct DeleteSection: View {
    let deleteAction: () -> Void

    var body: some View {
        Section {
            Button("删除当前选项", role: .destructive, action: deleteAction)
        }
    }
}
