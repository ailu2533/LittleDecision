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

    @AppStorage("decisionId") var decisionId: String = UUID().uuidString

    @State private var showAddDecisionSheet = false

    @Query private var decisions: [Decision] = []

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(decisions) { decision in

                        HStack {
                            Button(action: {
                                decisionId = decision.uuid.uuidString

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
                        }
                        .listRowBackground(decisionId == decision.uuid.uuidString ? Color(.systemFill) : Color(.systemBackground))
                        .swipeActions {
                            Button(role: .destructive) {
                                modelContext.delete(decision)
                            } label: {
                                Label("删除决定", systemImage: "trash.fill")
                            }

                            NavigationLink {
                                AddChoiceView(decision: decision)
                            } label: {
                                Label("编辑决定", systemImage: "square.and.pencil.circle")
                            }.tint(.green)
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
        }
        .sheet(isPresented: $showAddDecisionSheet, content: {
            AddChoiceView()
        })
    }
}

#Preview("DecisionManagementView") {
    CommonPreview(content: DecisionListView())
}
