//
//  DecisionListView.swift
//  LittleDecision
//
//  Created by ailu on 2024/4/15.
//

import Defaults
import SwiftData
import SwiftUI
import TipKit

struct UseDecisionTip: Tip {
    var title: Text {
        Text("使用提示")
    }

    var message: Text? {
        Text("点击**方框**使用决定\n向左滑动删除决定")
    }

    var image: Image? {
        Image(systemName: "lightbulb")
    }
}

struct DecisionListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Default(.decisionId) private var decisionId

    @State private var showAddDecisionSheet = false
    @Query(sort: [SortDescriptor(\Decision.createDate, order: .reverse)]) private var decisions: [Decision] = []

    let tip = UseDecisionTip()

    var savedDecisions: [Decision] {
        decisions.filter { $0.saved }
    }

    var body: some View {
        NavigationStack {
            Group {
                if savedDecisions.isEmpty {
                    emptyContentView
                } else {
                    decisionListView
                }
            }
            .scrollContentBackground(.hidden)
            .mainBackground()
            .navigationTitle("决定列表")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    addButton
                }
            }
        }
        .sensoryFeedback(.selection, trigger: decisionId)
        .sheet(isPresented: $showAddDecisionSheet) {
            DecisionAddView()
        }
    }

    private var decisionListView: some View {
        List {
            ForEach(savedDecisions) { decision in
                decisionRow(for: decision)
            }
            .listRowSeparator(.hidden)
            tipView
        }
    }

    private func decisionRow(for decision: Decision) -> some View {
        HStack {
            selectionIcon(for: decision)
            NavigationLink(destination: DecisionEditorView(decision: decision)) {
                decisionInfo(for: decision)
            }
        }
        .frame(height: 42)
        .swipeActions {
            deleteButton(for: decision)
        }
    }

    private var emptyContentView: some View {
        ContentUnavailableView(label: {
            Label("没有决定", systemImage: "tray.fill")
        }, actions: {
            Text("请按右上方的+添加决定")
                .foregroundStyle(.secondary)
        })
    }

    private var addButton: some View {
        Button(action: {
            showAddDecisionSheet = true
        }, label: {
            Label("新增决定", systemImage: "plus.circle.fill")
        })
    }

    private func selectionIcon(for decision: Decision) -> some View {
        Button(action: {
            decisionId = decision.uuid
            dismiss()
        }, label: {
            Image(systemName: decisionId == decision.uuid ? "checkmark.circle.fill" : "circle")
                .imageScale(.large)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        })
        .buttonStyle(PlainButtonStyle())
    }

    private func decisionInfo(for decision: Decision) -> some View {
        VStack(alignment: .leading) {
            Text(decision.title).fontWeight(.bold)
            Text("\(decision.choices.count)个选项")
                .foregroundStyle(.secondary)
                .font(.caption)
        }
    }

    private func deleteButton(for decision: Decision) -> some View {
        Button(role: .destructive) {
            modelContext.delete(decision)

            do {
                try modelContext.save()
            } catch {
                Logging.shared.error("save")
            }

            if decision.uuid == decisionId {
                decisionId = savedDecisions.first?.uuid ?? UUID()
            }
        } label: {
            Label("删除决定", systemImage: "trash.fill")
        }
    }

    private var tipView: some View {
        TipView(tip, arrowEdge: .top)
            .listRowBackground(Color.accentColor.opacity(0.1))
            .tipBackground(Color.clear)
            .listRowSpacing(0)
    }
}
