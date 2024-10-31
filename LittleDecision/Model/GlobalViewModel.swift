//
//  GlobalViewModel.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/10/29.
//

import Combine
import Defaults
import Foundation
import Observation
import SwiftData
import SwiftUI

@Observable
class GlobalViewModel {
    // MARK: Lifecycle

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        subject.debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] action in
                guard let self else { return }
                handleAction(action: action)
            }
            .store(in: &cancellables)
    }

    // MARK: Internal

    var selectedChoice: ChoiceItem?
    private(set) var selectedDecision: Decision?

    private(set) var items: [ChoiceItem] = []

    var decisionDisplayMode: DecisionDisplayMode {
        selectedDecision?.displayModeEnum ?? .wheel
    }

    // MARK: Private

    private let subject = CurrentValueSubject<ChangeAction, Never>(.decisionUUID(Defaults[.decisionID]))

    private var cancellables = Set<AnyCancellable>()

    private var modelContext: ModelContext
}

enum ChangeAction {
    // 切换了Decision
    case decisionUUID(UUID)
    case userDefaultsEqualWeight(Bool)
    case userDefaultsNoRepeat(Bool)
    // 编辑Decision的相关字段
    case decisionEdited(UUID)
}

extension GlobalViewModel {
    public func send(_ action: ChangeAction) {
        subject.send(action)
    }

    private func handleAction(action: ChangeAction) {
        switch action {
        case let .decisionEdited(decisionUUID):
            guard decisionUUID == selectedDecision?.uuid else {
                return
            }

            items = selectedDecision?.unwrappedChoices.map { ChoiceItem(choice: $0) } ?? []

        case let .decisionUUID(decisionUUID):
            selectedDecision = fetchDecision(decisionID: decisionUUID)
            selectedChoice = nil
            items = selectedDecision?.unwrappedChoices.map { ChoiceItem(choice: $0) } ?? []
        case let .userDefaultsEqualWeight(equalWeight):
            items = selectedDecision?.unwrappedChoices.map { ChoiceItem(choice: $0) } ?? []
        case let .userDefaultsNoRepeat(noRepeat):
            items = selectedDecision?.unwrappedChoices.map { ChoiceItem(choice: $0) } ?? []
        }
    }

    private func fetchDecision(decisionID: UUID) -> Decision? {
        let predicate = #Predicate<Decision> { $0.uuid == decisionID }
        let descriptor = FetchDescriptor(predicate: predicate)

        return try? modelContext.fetch(descriptor).first
    }
}

extension GlobalViewModel {
    public func saveChoice(decision: Decision, title: String, weight: Int) {
        let choice = Choice(content: title, weight: weight)
        choice.decision = decision
        try? modelContext.save()

        send(.decisionEdited(decision.uuid))
    }

    public func deleteDecision(_ decision: Decision) {
        if decision.uuid == selectedDecision?.uuid {
            selectedDecision = nil
            selectedChoice = nil

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

    public func deleteChoice(_ choice: Choice) {
        modelContext.delete(choice)
        try? modelContext.save()

        if let decision = choice.decision, decision.uuid == selectedDecision?.uuid {
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
