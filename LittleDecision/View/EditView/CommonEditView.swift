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

/// 表示单个选项的视图。
struct ChoiceRow: View {
    @Bindable var choice: Choice
    @Binding var tappedChoiceUUID: UUID?
    @FocusState private var focusedField: Field?

    @Environment(\.modelContext) private var modelContext
    @Environment(DecisionViewModel.self) private var vm

    var decision: Decision
    @Binding var totalWeight: Int

    enum Field {
        case title, weight
    }

    var body: some View {
        HStack {
            if tappedChoiceUUID == choice.uuid {
                VStack {
                    TextField("选项名", text: $choice.title)
                        .focused($focusedField, equals: .title)
                        .onAppear {
                            DispatchQueue.main.async {
                                focusedField = .title
                            }
                        }
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .weight
                        }

                    TextField("权重", value: $choice.weight, formatter: NumberFormatter())
                        .focused($focusedField, equals: .weight)
                        .keyboardType(.numberPad)
                        .toolbar {
                            if focusedField == .weight || focusedField == .title {
                                ToolbarItemGroup(placement: .keyboard) {
                                    switch focusedField {
                                    case .title:
                                        Text("选项名不能为空")
                                    case .weight:
                                        Text("权重需要于0")
                                    case nil:
                                        EmptyView()
                                    }

                                    Spacer()
                                    Button("继续新增") {
                                        let newChoice = vm.addNewChoice(to: decision)
                                        tappedChoiceUUID = newChoice.uuid
                                        totalWeight += choice.weight - 1
                                    }.disabled(choice.title.isEmpty)
                                    Button("完成") {
                                        focusedField = nil
                                        tappedChoiceUUID = nil
                                        if choice.title.isEmpty {
                                            vm.deleteChoice(from: decision, choice: choice)
                                        }
                                        totalWeight = decision.totalWeight
                                    }
                                }
                            }
                        }

                        .onChange(of: choice.weight) { _, newValue in
                            if newValue <= 0 {
                                choice.weight = 1
                            }
                        }

                        .onSubmit {
                            focusedField = nil
                        }
                }

            } else {
                HStack {
                    Text(choice.title)
                    Spacer()
                    Text("\(probability())%")
                        .monospaced()
                        .frame(width: 64, alignment: .trailing)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(.accent.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                }.contentShape(Rectangle())
                    .onTapGesture {
                        tappedChoiceUUID = choice.uuid
                    }
            }
        }
    }

    func probability() -> String {
        let result = Double(choice.weight) / Double(totalWeight) * 100

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0

        return formatter.string(from: NSNumber(value: result)) ?? "0"
    }
}
