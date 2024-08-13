//
//  CommonEditView.swift
//  LittleDecision
//
//  Created by ailu on 2024/6/8.
//

import SwiftUI
import TipKit

struct ChoiceTip: Tip {
    var image: Image? {
        Image(systemName: "lightbulb")
    }

    var title: Text {
        Text("编辑选项")
    }

    var message: Text? {
        Text("**点击选项**可以编辑选项名和权重\n被选中概率=权重/总权重\n**向左滑动**删除选项")
    }
}

/// 主视图，用于编辑决策和其选项。
struct CommonEditView: View {
    @Bindable var decision: Decision
    @Environment(DecisionViewModel.self) private var vm
    @Environment(\.modelContext) private var modelContext
    @State private var tappedChoiceUUID: UUID?
    @State private var totalWeight = 0
    private let tip = ChoiceTip()

    var body: some View {
        Form {
            decisionTitleSection
            choicesSection
            addChoiceSection
        }
        .onAppear { totalWeight = decision.totalWeight }
        .navigationBarTitleDisplayMode(.inline)
    }

    private var decisionTitleSection: some View {
        Section("决定名") {
            TextField("决定名", text: $decision.title)
                .font(.title3)
                .submitLabel(.done)
        }
    }

    private var choicesSection: some View {
        Section {
            List {
                ForEach(decision.sortedChoices) { choice in
                    ChoiceRow(choice: choice, tappedChoiceUUID: $tappedChoiceUUID, decision: decision, totalWeight: $totalWeight)
                }
                .onDelete(perform: deleteChoices)

                if !decision.choices.isEmpty {
                    tipView
                }
            }
        } header: {
            HStack {
                Text("选项列表")
                Spacer()
                Text("总权重 \(totalWeight)")
            }
        }
    }

    private var tipView: some View {
        TipView(tip, arrowEdge: .top)
            .tipBackground(Color.clear)
            .listRowBackground(Color.accentColor.opacity(0.1))
            .listSectionSpacing(0)
            .listRowSpacing(0)
    }

    private var addChoiceSection: some View {
        Section {
            Button("新增选项") {
                let newChoice = vm.addNewChoice(to: decision)
                tappedChoiceUUID = newChoice.uuid
                totalWeight += 1
            }
        }
    }

    private func deleteChoices(at indexSet: IndexSet) {
        vm.deleteChoices(from: decision, at: indexSet)
        totalWeight = decision.totalWeight
    }
}

