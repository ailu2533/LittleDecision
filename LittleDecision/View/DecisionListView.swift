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

    @AppStorage("decisionId") var decisionId: String = UUID().uuidString

//    @Binding private var didVersion: Int

    @State private var showAddDecisionSheet = false

    @State private var editingDecision: Decision? = nil

    @Environment(\.dismiss) private var dismiss

    @Query private var decisions: [Decision] = []

    @State private var sheetEnum: DecisionManagementSheetEnum?

    init(didVersion: Binding<Int>) {
//        _didVersion = didVersion
        print("DecisionManagementView")
    }

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(decisions) { decision in

                        HStack {
                            Button(action: {
                                decisionId = decision.uuid.uuidString
//                                didVersion += 1
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

                        }.swipeActions {
                            NavigationLink {
                                AddChoiceView(decision: decision)
                            } label: {
                                Label("编辑决定", systemImage: "ellipsis.circle")
                            }
                        }
                    }
                }
            }

            .navigationTitle("决定列表")
            .navigationBarTitleDisplayMode(.inline)

            .toolbar(content: {
                ToolbarItem {
                    Button(action: {
                        editingDecision = nil
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
    CommonPreview(content: DecisionListView(didVersion: .constant(0)))
}
