//
//  CommonEditView.swift
//  LittleDecision
//
//  Created by ailu on 2024/6/8.
//

import SwiftUI

struct CommonEditView: View {
    @Bindable var decision: Decision

//    @State private var inputChoiceTitle: String = ""
//    @State private var inputChoiceWeight: String = ""

    @Environment(\.dismiss)
    private var dismiss

    @Environment(DecisionViewModel.self)
    private var vm

    @Environment(\.modelContext)
    private var modelContext

    @State private var tappedChoiceUUID: UUID?

    var choices: [Choice] {
        decision.choices.sorted(by: { $0.sortValue < $1.sortValue })
    }

    var body: some View {
        Form {
            Section("决定名") {
                TextField("决定名", text: $decision.title)
                    .submitLabel(.done)
            }

            Section(header: Text("选项列表")) {
                List {
                    ForEach(choices) { choice in
                        ChoiceRow(choice: choice, tappedChoiceUUID: $tappedChoiceUUID, decision: decision)
                    }
                    .onDelete { indexSet in
                        vm.deleteChoices(from: decision, at: indexSet)
                        decision.resetTotalWeight()
                    }
                }
            }

            Section {
                Button("新增选项") {
                    addNewChoice()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func addNewChoice() {
        let newChoice = vm.addNewChoice(to: decision)
        tappedChoiceUUID = newChoice.uuid
    }
}

struct ChoiceRow: View {
    @Bindable var choice: Choice
    @Binding var tappedChoiceUUID: UUID?
    @FocusState private var focusedField: Field?

    @Environment(\.modelContext)
    private var modelContext

    @Environment(DecisionViewModel.self)
    private var vm

    var decision: Decision

    enum Field {
        case title, weight
    }

    private func addNewChoice() {
        let newChoice = vm.addNewChoice(to: decision)
        tappedChoiceUUID = newChoice.uuid
    }

    var body: some View {
        HStack {
            if tappedChoiceUUID == choice.uuid {
                VStack {
                    TextField("选项名", text: $choice.title)
                        .focused($focusedField, equals: .title)
                        .onAppear {
                            DispatchQueue.main.async {
                                self.focusedField = .title
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
                                        Text("权重需要大于0")
                                    case nil:
                                        EmptyView()
                                    }

                                    Spacer() // 使文本居中
                                    Button("继续新增") {
                                        addNewChoice()
                                    }.disabled(choice.title.isEmpty)
                                    Button("完成") {
                                        focusedField = nil // 关闭键盘
                                        tappedChoiceUUID = nil
                                        if choice.title.isEmpty {
                                            vm.deleteChoice(from: decision, choice: choice)
                                        }
                                    }
                                }
                            }
                        }

                        .onChange(of: choice.weight, { _, newValue in
                            if newValue <= 0 {
                                choice.weight = 1
                            }
                        })

                        .onSubmit {
                            focusedField = nil
                        }
                }

            } else {
                HStack {
                    Text(choice.title)
                    Spacer()
                    Text("\(choice.weight)")

                    Text("\(probability())%")
                        .frame(width: 60, alignment: .trailing)

                }.contentShape(Rectangle())
                    .onTapGesture {
                        tappedChoiceUUID = choice.uuid
                    }
            }
        }
    }

    func probability() -> String {
        let result = Double(choice.weight) / Double(decision.totalWeight) * 100
        return String(format: "%.2f", result)
    }
}
