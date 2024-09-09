//
//  DecisionRow.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/9.
//

import Defaults
import SwiftUI

struct DecisionRow: View {
    let decision: Decision

    var body: some View {
        HStack {
            SelectionIcon(decision: decision)
            NavigationLink(destination: DecisionEditorView(decision: decision)) {
                DecisionListRowLabel(decision: decision)
            }
        }
        .swipeActions {
            DeleteDecisionButton(decision: decision)
        }
    }
}
