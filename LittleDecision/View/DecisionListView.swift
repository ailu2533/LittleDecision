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
    @AppStorage("decisionId") var decisionId: String = UUID().uuidString
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
            ChoiceAddView()
        }
    }

    private var decisionListView: some View {
        List {
            ForEach(savedDecisions) { decision in
                decisionRow(for: decision)
            }
            tipView
        }
    }

    private func decisionRow(for decision: Decision) -> some View {
        HStack {
            selectionIcon(for: decision)
            NavigationLink(destination: ChoiceEditView(decision: decision)) {
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
            Label("新增决定", systemImage: "plus")
        })
    }

    private func selectionIcon(for decision: Decision) -> some View {
        Image(systemName: decisionId == decision.uuid.uuidString ? "checkmark.square" : "square")
            .imageScale(.large)
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .onTapGesture {
                decisionId = decision.uuid.uuidString
            }
    }

    private func decisionInfo(for decision: Decision) -> some View {
        VStack(alignment: .leading) {
            Text(decision.title).fontWeight(.bold)
            Text("\(decision.choices.count)个选项")
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

            if decision.uuid.uuidString == decisionId {
                decisionId = savedDecisions.first?.uuid.uuidString ?? UUID().uuidString
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
