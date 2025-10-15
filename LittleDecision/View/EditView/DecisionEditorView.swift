//
//  DecisionEditorView.swift
//  LittleDecision
//
//  Created by ailu on 2024/6/8.
//

import SwiftUI

struct DecisionEditorView: View {
    // MARK: Lifecycle

    init(decision: Decision) {
        self.decision = decision
    }

    // MARK: Internal

    var decision: Decision

    var body: some View {
        CommonEditView(decision: decision)
            .navigationTitle("编辑决定")
    }
}
