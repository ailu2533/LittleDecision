//
//  DecisionListView.swift
//  LittleDecision
//
//  Created by ailu on 2024/4/15.
//

import SwiftUI


struct DecisionListView: View {
    @Environment(\.modelContext) private var modelContext

    @AppStorage("decisionId") var decisionId: String = UUID().uuidString

//    @Binding private var didVersion: Int

    @State private var showAddDecisionSheet = false

    @State private var editingDecision: Decision?

    @Environment(\.dismiss) private var dismiss

//    @Query private var decisions: [Decision] = []
    
    private var decisions: [Decision] = [
        .init(title: "1", choices: [
            .init(content: "1", weight: 2, sortValue: 1),
            .init(content: "2", weight: 3, sortValue: 2)
        ])
    ]

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
                                Image(systemName: "ellipsis.circle")
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
//        .sheet(isPresented: $showAddDecisionSheet, content: {
//            AddChoiceView(decision: editingDecision)
//        })
    }
}

#Preview("DecisionManagementView") {
    CommonPreview(content: DecisionListView(didVersion: .constant(0)))
}

