//
//  DecisionViewModel.swift
//  LittleDecision
//
//  Created by ailu on 2024/4/8.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
class DecisionViewModel {
    let modelContext: ModelContext
    var navigationPath = NavigationPath()

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func addNewChoice(to decision: Decision) -> Choice {
        let newChoice = Choice(content: "", weight: 1)
        decision.choices.append(newChoice)
        return newChoice
    }

    func deleteChoice(from decision: Decision, choice: Choice) {
        modelContext.delete(choice)
        decision.choices.removeAll { $0.uuid == choice.uuid }
    }

    func deleteChoices(from decision: Decision, at offsets: IndexSet) {
        let choicesToDelete = offsets.map { decision.sortedChoices[$0] }
        choicesToDelete.forEach { modelContext.delete($0) }
        decision.choices.removeAll { choice in
            choicesToDelete.contains { $0.uuid == choice.uuid }
        }
    }
}
