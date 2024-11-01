//
//  GlobalViewModel+Choice.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/10/31.
//

import Foundation

extension GlobalViewModel {
    public func deleteChoice(_ choice: Choice) {
        if selectedChoice?.uuid == choice.uuid {
            setSelectedChoice(nil)
        }

        guard let decision = choice.decision else { return }

        modelContext.delete(choice)
        try? modelContext.save()

        if decision.uuid == selectedDecision?.uuid {
            send(.decisionEdited(decision.uuid))
        }
    }

    func deleteChoices(from decision: Decision, at offsets: IndexSet) {
        let choicesToDelete = offsets.map { decision.sortedChoices[$0] }
        choicesToDelete.forEach { modelContext.delete($0) }

        choicesToDelete.forEach { choice in
            decision.choices?.removeAll { choice.uuid == $0.uuid }
        }

        try? modelContext.save()

        send(.decisionEdited(decision.uuid))
    }

    func saveChoice(decision: Decision, title: String, weight: Int) {
        let choice = Choice(content: title, weight: weight)
        choice.decision = decision
        try? modelContext.save()

        send(.decisionEdited(decision.uuid))
    }

    func saveChoice(_ choice: Choice) {
        guard let context = choice.modelContext else {
            return
        }

        guard let decision = choice.decision else {
            return
        }

        try? context.save()

        send(.decisionEdited(decision.uuid))
    }

    func addChoice(for decision: Decision, title: String, weight: Int) {
        let choice = Choice(content: title, weight: weight)
        choice.decision = decision
        try? modelContext.save()

        send(.decisionEdited(decision.uuid))
    }
}
