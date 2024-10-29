//
//  DecisionRow.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/9.
//

import Defaults
import SwiftUI

struct DecisionRow: View {
    // MARK: Internal

    let decision: Decision
    let isSelected: Bool
    let selectAction: () -> Void

    var body: some View {
        HStack {
            selectionButton
            NavigationLink(destination: DecisionEditorView(decision: decision)) {
                DecisionListRowLabel(decision: decision)
            }
        }
    }

    // MARK: Private

    private var selectionButton: some View {
        Button(action: selectAction) {
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .imageScale(.large)
                .fontWeight(.semibold)
                .foregroundColor(.accentColor)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
