//
//  DecisionTitle.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/10.
//

import SwiftUI

struct MainViewDecisionTitle: View {
    // MARK: Internal

    var decision: Decision?

    var body: some View {
        if let decision {
            Button {
                showSheet = true
            } label: {
                label(decision: decision)
            }
            .sheet(isPresented: $showSheet) {
                NavigationStack {
                    CommonEditView(decision: decision)
                        .navigationTitle("编辑决定")
                        .navigationBarTitleDisplayMode(.inline)
                }
            }

        } else {
            Text("没有决定")
        }
    }

    func label(decision: Decision) -> some View {
        Label(
            title: {
                Text(decision.title)
                    .multilineTextAlignment(.center)
                    .truncationMode(.middle)
                    .font(.headline)
            },
            icon: {
                Image(systemName: "pencil.and.outline")
            }
        )
        .labelStyle(.titleAndIcon)
    }

    // MARK: Private

    @State private var showSheet = false
}
