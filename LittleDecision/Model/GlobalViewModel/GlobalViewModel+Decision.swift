//
//  Decision.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/11/15.
//

import Defaults
import Foundation
import SwiftData

// MARK: GlobalViewModel + Decision

extension GlobalViewModel {
    public func deleteDecision(_ decision: Decision) {
        if decision.uuid == selectedDecision?.uuid {
            setSelectedDecision(nil)
            setSelectedChoice(nil)

            modelContext.delete(decision)
            try? modelContext.save()

            let decisionID = fetchFirstDecision()?.uuid ?? UUID()
            Defaults[.decisionID] = decisionID

            send(.decisionUUID(decisionID))
        } else {
            modelContext.delete(decision)
            try? modelContext.save()
        }
    }

    public func selectDecision(_ decision: Decision) {
        Defaults[.decisionID] = decision.uuid
        send(.decisionUUID(decision.uuid))
    }

    func fetchFirstDecision() -> Decision? {
        var fetchDescriptor = FetchDescriptor<Decision>(
            sortBy: [
                SortDescriptor(\Decision.createDate, order: .reverse),
                SortDescriptor(\Decision.uuid, order: .reverse),
            ]
        )

        fetchDescriptor.fetchLimit = 1

        return try? modelContext.fetch(fetchDescriptor).first
    }
}
