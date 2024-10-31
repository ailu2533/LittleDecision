//
//  DecisionRow.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/9.
//

import SwiftUI

struct DecisionRow: View {
    let decision: Decision
    let isSelected: Bool
    let selectAction: () -> Void

    var body: some View {
        HStack {
            Button {
                selectAction()
            } label: {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .imageScale(.large)
                    .fontWeight(.semibold)
                    .foregroundColor(.accentColor)
            }
            .buttonStyle(.plain)

            NavigationLink {
                DecisionEditorView(decision: decision)
            } label: {
                DecisionListRowLabel(decision: decision)
            }
        }
    }
}
