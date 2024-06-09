//
//  CommonEditView.swift
//  LittleDecision
//
//  Created by ailu on 2024/6/8.
//

import SwiftUI

struct CommonEditView: View {
    @Bindable var decision: Decision

    @State private var inputChoiceTitle: String = ""
    @State private var inputChoiceWeight: String = ""

    @Environment(\.dismiss)
    private var dismiss

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
                        ChoiceRow(choice: choice, tappedChoiceUUID: $tappedChoiceUUID)
                    }
                    .onDelete(perform: deleteChoices)
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

    private func deleteChoices(at offsets: IndexSet) {
        offsets.map { choices[$0] }.forEach(modelContext.delete)
        decision.choices.removeAll(where: { choice in offsets.contains(where: { choices[$0].id == choice.id }) })
    }

    private func addNewChoice() {
        let newChoice = Choice(content: inputChoiceTitle, weight: Int(inputChoiceWeight) ?? 1, sortValue: Double(decision.choices.count))
        decision.choices.append(newChoice)
        tappedChoiceUUID = newChoice.uuid
    }
}

struct ChoiceRow: View {
    @Bindable var choice: Choice
    @Binding var tappedChoiceUUID: UUID?
    @FocusState private var focusedField: Field?

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
                                        Spacer() // 使文本居中
                                        Text("请输入大于0的权重").opacity(focusedField == .title ? 0 : 1)
                                        Spacer() // 使文本居中
                                        Button("完成") {
                                            focusedField = nil // 关闭键盘
                                            tappedChoiceUUID = nil
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
                }.contentShape(Rectangle())
                    .onTapGesture {
                        tappedChoiceUUID = choice.uuid
                    }
            }
        }
    }
}
