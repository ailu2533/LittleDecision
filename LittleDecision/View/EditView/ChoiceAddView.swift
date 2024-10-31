//
//  ChoiceAddView2.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/15.
//

import LemonViews
import SwiftUI

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
        .mainBackground()
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

    private var choiceDetailsSection: some View {
        Section {
            ChoiceTitleView(title: $title)
            ChoiceWeightView(weight: $weight)
        }
    }

    private var weightInfoSection: some View {
        Section {
            LabeledContent("总权重", value: "\(totalWeight + weight)")
            LabeledContent("概率", value: probability(weight, totalWeight + weight))
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
            decision.choices?.append(choice)
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
