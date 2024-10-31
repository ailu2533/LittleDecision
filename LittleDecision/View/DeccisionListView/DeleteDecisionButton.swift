//
//  DeleteButton.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/9.
//

import Defaults
import SwiftUI

struct DeleteDecisionButton: View {
    // MARK: Internal

    let decision: Decision

    var body: some View {
        Button(role: .destructive) {
            globalViewModel.deleteDecision(decision)
        } label: {
            Label("删除决定", systemImage: "trash.fill")
        }
    }

    // MARK: Private

    @Environment(GlobalViewModel.self) private var globalViewModel

//    @Environment(\.modelContext) private var modelContext
//    @Default(.decisionID) private var decisionID
}
