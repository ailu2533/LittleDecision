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

struct DecisionListView: View {
    // MARK: Internal

    var savedDecisions: [Decision] {
        decisions.filter { $0.saved }
    }

    var body: some View {
        NavigationStack {
            Group {
                if savedDecisions.isEmpty {
                    EmptyContentView()
                } else {
                    DecisionListContentView(savedDecisions: savedDecisions)
                }
            }
            .mainBackground()
            .navigationTitle("决定列表")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    AddButton(showAddDecisionSheet: $showAddDecisionSheet)
                }
            }
        }
        .sensoryFeedback(.selection, trigger: decisionID)
        .sheet(isPresented: $showAddDecisionSheet) {
            TemplateList(showSheet: $showAddDecisionSheet)
        }
    }

    // MARK: Private

    @Environment(\.modelContext)
    private var modelContext

    @Environment(\.dismiss)
    private var dismiss

    @Query(sort: [SortDescriptor(\Decision.createDate, order: .reverse)])
    private var decisions: [Decision] = []

    @Default(.decisionID) private var decisionID
    @State private var showAddDecisionSheet = false
}

struct EmptyContentView: View {
    var body: some View {
        ContentUnavailableView(label: {
            Label("没有决定", systemImage: "tray.fill")
        }, actions: {
            Text("请按右上方的+添加决定")
                .foregroundStyle(.secondary)
        })
    }
}

struct AddButton: View {
    @Binding var showAddDecisionSheet: Bool

    var body: some View {
        Button(action: {
            showAddDecisionSheet = true
        }, label: {
            Label("新增决定", systemImage: "plus.circle.fill")
        })
    }
}

