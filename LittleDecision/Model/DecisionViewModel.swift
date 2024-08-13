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

    func queryDecisions() -> Decision? {
        let predicate = #Predicate<Decision> { _ in
            true
        }

        var descriptor = FetchDescriptor(predicate: predicate)

        descriptor.fetchLimit = 1

        descriptor.propertiesToFetch = [\Decision.uuid]

        do {
            return try modelContext.fetch(descriptor).first
        } catch {
            Logging.shared.error("currentDecision: \(error)")
            return nil
        }
    }

    // 查询所有 decision

    func fetchAllDecisions() -> [Decision] {
        let descriptor = FetchDescriptor<Decision>(sortBy: [SortDescriptor<Decision>(\Decision.createDate, order: .reverse)])

        do {
            let res = try modelContext.fetch(descriptor)
            return res
        } catch {
            print(error.localizedDescription)
        }

        return []
    }

    // 根据 uuid 查询 decision
    func fetchDecisionBy(uuid: UUID) -> Decision? {
        let desciptor = FetchDescriptor<Decision>(predicate: #Predicate { decision in
            decision.uuid == uuid
        })

        do {
            return try modelContext.fetch(desciptor).first
        } catch {
            Logging.shared.error("fetchDecisionBy uuid: \(uuid)")
            return nil
        }
    }

    public func addNewChoice(to decision: Decision) -> Choice {
        let newChoice = Choice(content: "", weight: 1)
        decision.choices.append(newChoice)
        return newChoice
    }

    public func deleteChoice(from decision: Decision, choice: Choice) {
        modelContext.delete(choice)

        decision.choices.removeAll {
            $0.uuid == choice.uuid
        }
    }

    public func deleteChoices(from decision: Decision, at offsets: IndexSet) {
        print("idx:\(offsets)")
        let choices = decision.sortedChoices
        offsets.map { choices[$0] }.forEach(modelContext.delete)
        decision.choices.removeAll(where: { choice in offsets.contains(where: { choices[$0].id == choice.id }) })
    }
}
