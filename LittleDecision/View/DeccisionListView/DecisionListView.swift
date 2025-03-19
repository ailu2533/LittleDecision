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

// MARK: - DecisionListView

struct DecisionListView: View {
    // MARK: Internal

    var body: some View {
        NavigationStack {
            DecisionListContentView(decisions: decisions)
                .overlay {
                    if decisions.isEmpty {
                        EmptyContentView()
                    }
                }
//                .mainBackground()
                .navigationTitle("决定列表")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Menu {
                            Button {
                                show2 = true
                            } label: {
                                Label("创建新决定", systemSymbol: .plusApp)
                            }

                            Button {
                                showAddDecisionSheet = true
                            } label: {
                                Label("从模板库添加", systemSymbol: .listStar)
                            }

                        } label: {
                            Text("新增")
                        }
                    }
                }
        }
        .sheet(isPresented: $showAddDecisionSheet) {
            TemplateList(showSheet: $showAddDecisionSheet)
        }
        .sheet(isPresented: $show2) {
            NavigationStack {
                DecisionAddView(showSheet: $show2, template: DecisionTemplate(title: "", tags: [], choices: []))
            }
        }
    }

    // MARK: Private

    @State private var show2 = false

    @Query(
        filter: #Predicate<Decision> { decision in
            decision.saved == true
        },
        sort: [
            SortDescriptor(\Decision.createDate, order: .reverse),
        ]
    ) private var decisions: [Decision]

    @State private var showAddDecisionSheet = false
}

// MARK: - EmptyContentView

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
