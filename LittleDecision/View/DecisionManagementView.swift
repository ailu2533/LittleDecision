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

            }.navigationTitle("新增决定")
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

struct DecisionManagementView: View {
    @Environment(\.modelContext) private var modelContext

    @AppStorage("decisionId") var decisionId: String = UUID().uuidString

    @Binding private var didVersion: Int

    @State private var showAddDecisionSheet = false

    @Environment(\.dismiss) private var dismiss

    @Query private var decisions: [Decision] = []

    init(didVersion: Binding<Int>) {
        _didVersion = didVersion
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(decisions) { decision in

                        HStack {
                            Button(action: {
                                decisionId = decision.uuid.uuidString
                                didVersion += 1
                                dismiss()
                            }, label: {
                                HStack {
                                    Text(decision.title)
                                        .foregroundStyle(Color.primary)
                                        .fontWeight(.regular)

                                    Spacer()
                                }

                            })

                            Spacer()

                            NavigationLink {
                                AddChoiceView(decision: decision)
                            } label: {
                                Image(systemName: "ellipsis.circle")
                            }
                        }

                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.blue.opacity(decisionId == decision.uuid.uuidString ? 0.1 : 0))
                                .stroke(.gray.opacity(0.5))
                                .shadow(radius: 8)
                        }

                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("决定列表")
            .navigationBarTitleDisplayMode(.inline)

            .toolbar(content: {
                ToolbarItem {
                    Button(action: {
                        showAddDecisionSheet = true
                    }, label: {
                        Label("新增决定", systemImage: "plus")
                    })
                }
            })
            .sheet(isPresented: $showAddDecisionSheet, content: {
                AddChoiceView()
            })
        }
    }
}

#Preview("AddDecisionView") {
    CommonPreview(content: AddChoiceView())
}

#Preview("DecisionManagementView") {
    CommonPreview(content: DecisionManagementView(didVersion: .constant(0)))
}
