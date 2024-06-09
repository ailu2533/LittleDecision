//
//  DecisionListView.swift
//  LittleDecision
//
//  Created by ailu on 2024/4/15.
//

import SwiftData
import SwiftUI

struct DecisionListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Environment(DecisionViewModel.self) private var vm

    @AppStorage("decisionId") var decisionId: String = UUID().uuidString

    @State private var showAddDecisionSheet = false

    @Query private var decisions: [Decision] = []

    var body: some View {
        List {
            ForEach(decisions.filter({ decision in
                decision.saved == true
            })) { decision in

                HStack {
                    Image(systemName: decisionId == decision.uuid.uuidString ? "checkmark.circle" : "circle")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                        .onTapGesture {
                            decisionId = decision.uuid.uuidString
                        }
                        .frame(minWidth: 40)

                    NavigationLink(destination: {
                        ChoiceEditView(decision: decision)
                    }, label: {
                        VStack(alignment: .leading) {
                            Text(decision.title)
                            Text("\(decision.choices.count)个选项")
                                .font(.caption)
                        }

                    })
                }
                .frame(height: 42)

                .swipeActions {
                    Button(role: .destructive) {
                        modelContext.delete(decision)

                        do {
                            try modelContext.save()
                        } catch {
                            Logging.shared.error("save")
                        }

                        if decision.uuid.uuidString == decisionId {
                            decisionId = decisions.filter({ decision in
                                decision.saved == true
                            }).first?.uuid.uuidString ?? UUID().uuidString
                        }

                    } label: {
                        Label("删除决定", systemImage: "trash.fill")
                    }
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
            ChoiceAddView()
        })
    }
}

#Preview("DecisionManagementView") {
    CommonPreview(content: DecisionListView())
}
