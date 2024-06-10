//
//  DecisionListView.swift
//  LittleDecision
//
//  Created by ailu on 2024/4/15.
//

import SwiftData
import SwiftUI
import TipKit

struct UseDecisionTip: Tip {
    var title: Text {
        Text("使用决定")
    }

    var message: Text? {
        Text("点击决定最左侧的圆圈来使用决定")
    }

    var image: Image? {
        Image(systemName: "lightbulb")
    }
}

struct DecisionListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Environment(DecisionViewModel.self) private var vm

    @AppStorage("decisionId") var decisionId: String = UUID().uuidString

    @State private var showAddDecisionSheet = false

    @Query private var decisions: [Decision] = []

    let tip = UseDecisionTip()

    var savedDecision: [Decision] {
        return decisions.filter({ decision in
            decision.saved == true
        })
    }

    var body: some View {
        let decisions = savedDecision
        VStack {
            List {
                ForEach(decisions) { decision in

                    HStack {
                        Image(systemName: decisionId == decision.uuid.uuidString ? "checkmark.square" : "square")
                            .imageScale(.large)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.accentColor)

                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .onTapGesture {
                                decisionId = decision.uuid.uuidString
                            }

                        NavigationLink(destination: {
                            ChoiceEditView(decision: decision)
                        }, label: {
                            VStack(alignment: .leading) {
                                Text(decision.title).fontWeight(.bold)
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
                if !decisions.isEmpty {
                    TipView(tip)
                        .listRowBackground(Color.clear)
                }
            }
        }
        .sensoryFeedback(.selection, trigger: decisionId)

        .overlay(content: {
            if decisions.isEmpty {
                ContentUnavailableView(label: {
                    Label("没有决定", systemImage: "tray.fill")
                }, actions: {
                    Text("请按右上方的+添加决定")
                        .foregroundStyle(.secondary)
                })
            }

        })

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
