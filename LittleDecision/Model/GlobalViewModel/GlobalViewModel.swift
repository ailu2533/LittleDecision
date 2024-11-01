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

// MARK: - GlobalViewModel

@Observable
class GlobalViewModel {
    // MARK: Lifecycle

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        subject.debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .sink { [weak self] action in
                guard let self else { return }
                handleAction(action: action)
            }
            .store(in: &cancellables)
    }

    // MARK: Internal

    private(set) var selectedChoice: ChoiceItem?
    private(set) var selectedDecision: Decision?

    private(set) var items: [ChoiceItem] = []

    let modelContext: ModelContext

    // MARK: spin wheel prop

    private(set) var spinWheelTapCount = 0
    private(set) var spinWheelRotateAngle: Double = 0.0
    private(set) var spinWheelIsRunning = false

    var decisionDisplayMode: DecisionDisplayMode {
        selectedDecision?.displayModeEnum ?? .wheel
    }

    func setSelectedChoice(_ choice: ChoiceItem?) {
        self.selectedChoice = choice

        if let choice {
            selectedChoice(choice)
        }
    }

    func setSelectedDecision(_ decision: Decision?) {
        self.selectedDecision = decision
    }

    // MARK: Private

    private let subject = CurrentValueSubject<ChangeAction, Never>(.decisionUUID(Defaults[.decisionID]))

    private var cancellables = Set<AnyCancellable>()
}

extension GlobalViewModel {
    func startSpinning() {
        guard !spinWheelIsRunning else { return }

        setSelectedChoice(nil)

        if let (choice, angle) = LotteryViewModel.select(from: items) {
            let extraRotation = Defaults[.rotationTime] * 360.0
            let targetAngle = (270 - angle + 360 - spinWheelRotateAngle.truncatingRemainder(dividingBy: 360)) + extraRotation

            spinWheelIsRunning = true

            withAnimation(.easeInOut(duration: 3)) {
                spinWheelRotateAngle += targetAngle

            } completion: { [weak self] in
                guard let self else { return }
                setSelectedChoice(choice)
                spinWheelIsRunning = false
            }
        } else {
            restore()
            spinWheelIsRunning = false
        }
    }

    func restore() {
        if spinWheelIsRunning {
            return
        }

        selectedDecision?.unwrappedChoices.forEach { $0.enable = true }

        try? modelContext.save()

        selectedChoice = nil
        items = selectedDecision?.unwrappedChoices.map { ChoiceItem(choice: $0) } ?? []

        withAnimation {
            spinWheelRotateAngle -= spinWheelRotateAngle.truncatingRemainder(dividingBy: 360)
        }
        spinWheelRotateAngle = 0
    }
}

// MARK: +ChangeAction

extension GlobalViewModel {
    public func send(_ action: ChangeAction) {
        subject.send(action)
    }

    // MARK: handleAction

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
        case .userDefaultsEqualWeight:
            items = selectedDecision?.unwrappedChoices.map { ChoiceItem(choice: $0) } ?? []
        case .userDefaultsNoRepeat:
            items = selectedDecision?.unwrappedChoices.map { ChoiceItem(choice: $0) } ?? []
        }
    }

    // MARK: fetchDecision

    private func fetchDecision(decisionID: UUID) -> Decision? {
        let predicate = #Predicate<Decision> { $0.uuid == decisionID }
        let descriptor = FetchDescriptor(predicate: predicate)

        return try? modelContext.fetch(descriptor).first
    }

    // MARK: selectedChoice

    private func selectedChoice(_ choice: ChoiceItem) {
        selectedDecision?.choices?.forEach({
            if $0.uuid == choice.uuid {
                $0.enable = false
            }
        })

        try? modelContext.save()

        items = selectedDecision?.unwrappedChoices.map { ChoiceItem(choice: $0) } ?? []
    }
}
