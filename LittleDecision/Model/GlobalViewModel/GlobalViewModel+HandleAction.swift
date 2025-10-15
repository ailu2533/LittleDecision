//
//  GlobalViewModel+HandleAction.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/11/15.
//

import Foundation
import SwiftData

// MARK: +ChangeAction

extension GlobalViewModel {
    // MARK: handleAction

    func handleAction(action: ChangeAction) {
        Logging.shared.debug("handle action \(action)")

        switch action {
        case let .decisionEdited(decisionUUID):
            guard decisionUUID == selectedDecision?.uuid else {
                return
            }

            refreshItems()
        case let .decisionUUID(decisionUUID):
            guard let decisionUUID else {
                setSelectedDecision(nil)
                refreshItems()
                return
            }

            selectedDecision = fetchDecision(decisionID: decisionUUID)
            refreshItems()
        case .userDefaultsEqualWeight:
            refreshItems()
        case .userDefaultsNoRepeat:
            refreshItems()
        }
    }

    // MARK: fetchDecision

    private func fetchDecision(decisionID: UUID) -> Decision? {
        let predicate = #Predicate<Decision> { $0.uuid == decisionID }
        let descriptor = FetchDescriptor(predicate: predicate)

        return try? modelContext.fetch(descriptor).first
    }

    // MARK: selectedChoice
}
