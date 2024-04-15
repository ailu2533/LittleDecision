//
//  DecisionManagementView.swift
//  LittleDecision
//
//  Created by ailu on 2024/4/8.
//

import SwiftData
import SwiftUI

fileprivate struct EditableChoice: Identifiable {
    var id: UUID = UUID()

    var title: String = ""
    var weight: Int = 0
    var sortValue: Int = 0

    init(title: String, weight: Int, sortValue: Int) {
        self.title = title
        self.weight = weight
        self.sortValue = sortValue
    }

    func toChoice() -> Choice {
        return Choice(content: title, weight: weight, sortValue: sortValue)
    }
}

extension Choice {
    fileprivate func toEditable() -> EditableChoice {
        return EditableChoice(title: title, weight: weight, sortValue: sortValue)
    }
}

struct AddChoiceView: View {
    private var decision: Decision?

    @State private var decisionTitle: String = ""
    @State private var choices: [EditableChoice] = []

    init(decision: Decision? = nil) {
        print("hello \(decision?.title)")
        self.decision = decision
    }

    @Environment(\.dismiss) private var dismiss

    @Environment(\.modelContext) private var modelContext

    fileprivate func saveOrUpdate() {
        if let last = choices.last, last.title.isEmpty {
            choices.removeLast()
        }

        if let decision {
            decision.title = decisionTitle

            decision.choices.removeAll()
            choices.forEach {
                decision.choices.append($0.toChoice())
            }

        } else {
            let choiceModels = choices.map { $0.toChoice() }

            let decision = Decision(title: decisionTitle, choices: choiceModels)

            modelContext.insert(decision)
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section("决定") {
                        TextField("决定名", text: $decisionTitle)
                    }

                    Section("选项") {
                        List {
                            ForEach($choices) { choice in
                                HStack {
                                    TextField(text: choice.title) {
                                        Text("选项名")
                                    }

                                    Image(systemName: "xmark.circle").foregroundStyle(.red)
                                        .onTapGesture {
                                            withAnimation(.snappy) {
                                                choices.removeAll {
                                                    $0.id == choice.id
                                                }
                                            }
                                        }
                                }
                            }
                        }
                    }

                    Button(action: {
                        if let last = choices.last, last.title.isEmpty {
                            return
                        }

                        choices.append(.init(title: "", weight: 0, sortValue: choices.count))

                    }, label: {
                        Text("新增选项")
                    })
                }

            }.navigationTitle(decision == nil ? "新增决定" : "编辑决定")
                .toolbar(content: {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            saveOrUpdate()

                            dismiss()
                        }, label: {
                            Text("保存")
                        })
                    }
                })
        }
        .onAppear(perform: {
            if let decision {
                decisionTitle = decision.title
                let r = decision.choices.map { $0.toEditable() }
                choices = r.sorted(using: SortDescriptor(\.sortValue))
            }

            if choices.isEmpty {
                choices.append(EditableChoice(title: "", weight: 1, sortValue: 0))
            }

        })
    }
}

enum DecisionManagementSheetEnum: Identifiable {
    var id: UUID {
        UUID()
    }

    case add
    case edit(Decision)
}


#Preview("AddDecisionView") {
    CommonPreview(content: AddChoiceView())
}

