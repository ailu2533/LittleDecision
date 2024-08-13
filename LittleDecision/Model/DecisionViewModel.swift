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
    var modelContext: ModelContext
    var navigationPath: NavigationPath = .init()

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

        decision.choices.removeAll {
            $0.uuid == choice.uuid
        }
    }

    func deleteChoices(from decision: Decision, at offsets: IndexSet) {
        print("idx:\(offsets)")
        let choices = decision.sortedChoices
        offsets.map { choices[$0] }.forEach(modelContext.delete)
        decision.choices.removeAll(where: { choice in offsets.contains(where: { choices[$0].id == choice.id }) })
    }
}
