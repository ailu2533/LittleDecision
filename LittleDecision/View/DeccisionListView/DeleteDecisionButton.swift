//
//  DeleteButton.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/9.
//

import Defaults
import SwiftUI

struct DeleteDecisionButton: View {
    let decision: Decision

    @Environment(\.modelContext) private var modelContext
    @Default(.decisionId) private var decisionId

    var body: some View {
        Button(role: .destructive) {
            modelContext.delete(decision)
            do {
                try modelContext.save()
            } catch {
                Logging.shared.error("save")
            }
            if decision.uuid == decisionId {
                decisionId = modelContext.fetchedDecisions.first?.uuid ?? UUID()
            }
        } label: {
            Label("删除决定", systemImage: "trash.fill")
        }
    }
}
