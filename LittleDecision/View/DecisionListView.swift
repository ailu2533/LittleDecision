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
        @Bindable var vm = vm
       Group {
            VStack {
                List {
                    ForEach(decisions) { decision in

                        HStack {
                            DecisionListItem(text: decision.title, selected: decisionId == decision.uuid.uuidString)
                                .onTapGesture {
                                    decisionId = decision.uuid.uuidString
                                }
                            Spacer()
                            Image(systemName: "pencil.circle")
                                .onTapGesture {
                                    vm.navigationPath.append(decision)
                                }
                        }

                        .listRowBackground(decisionId == decision.uuid.uuidString ? Color(.systemFill) : Color(.systemBackground))
                        .swipeActions {
                            Button(role: .destructive) {
                                modelContext.delete(decision)
                            } label: {
                                Label("删除决定", systemImage: "trash.fill")
                            }
                        }
                    }
                }
                .navigationDestination(for: Decision.self, destination: {
                    AddChoiceView(decision: $0)
                })
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
