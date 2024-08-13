//
//  ChoiceEditView.swift
//  LittleDecision
//
//  Created by ailu on 2024/6/8.
//

import SwiftUI

struct ChoiceEditView: View {
    var decision: Decision

    init(decision: Decision) {
        self.decision = decision
    }

    var body: some View {
        CommonEditView(decision: decision)
            .navigationTitle("编辑决定")
    }
}
