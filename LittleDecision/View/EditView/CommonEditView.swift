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

    @State private var showAlert = false

    @State private var tappedChoiceUUID: UUID?

    var body: some View {
        Form {
            Section("决定名") {
                TextField(text: $decision.title) {
                    Text("决定名")
                }
            }

            Section(content: {
                List {
                    ForEach(decision.choices) { choice in

                        HStack {
                            if tappedChoiceUUID == choice.uuid {
                                VStack {
                                    TextField(text: Binding(get: {
                                        choice.title
                                    }, set: { newValue in
                                        choice.title = newValue
                                    })) {
                                        Text("选项名")
                                    }

                                    TextField("权重", value: Binding(get: {
                                        choice.weight
                                    }, set: { newValue in
                                        choice.weight = newValue
                                    }), formatter: NumberFormatter())
                                }

                            } else {
                                HStack {
                                    Text(choice.title)
                                    Spacer()
                                    Text(choice.weight.formatted())
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    tappedChoiceUUID = choice.uuid
                                }
                            }

                            if tappedChoiceUUID == choice.uuid {
                                Image(systemName: "checkmark.circle")
                                    .imageScale(.large)
                                    .foregroundStyle(Color.accentColor)
                                    .onTapGesture {
                                        tappedChoiceUUID = nil
                                    }
                            }
                        }

                    }.onDelete(perform: { indexSet in
                        let dels = indexSet.map { idx in
                            decision.choices[idx]
                        }

                        dels.forEach { choice in
                            modelContext.delete(choice)
                        }

                        decision.choices.removeAll { choice in
                            dels.contains { choice2 in
                                choice.id == choice2.id
                            }
                        }

                    })
                }

            }, header: {
                HStack {
                    Text("决定列表")
                    Spacer()
                    EditButton()
                }
            })

            Section {
                Button(action: {
                    let newChoice = Choice(content: inputChoiceTitle, weight: 100, sortValue: Double(decision.choices.count))
                    decision.choices.append(newChoice)
                    tappedChoiceUUID = newChoice.uuid
                }, label: {
                    Text("新增选项")
                })
            }
        }

        .navigationBarTitleDisplayMode(.inline)
    }
}
