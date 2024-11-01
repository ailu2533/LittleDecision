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

    // MARK: deck

    private(set) var deckBackDegree: CGFloat = 0
    private(set) var deckFrontDegree: CGFloat = -90
    private(set) var deckIsFlipped = false
    private(set) var deckEnableWiggle: Bool = false
    private(set) var deckText: String = ""
    private(set) var deckStatus: DeckStatus = .none

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

// GlobalViewModel + Card
extension GlobalViewModel {
    // MARK: Public

    // MARK: flip

    public func flip() {
        if deckStatus != .none {
            return
        }

        deckStatus = .isFlipping

//        tapCount += 1
        deckIsFlipped.toggle()

        if deckIsFlipped {
            flipToFront()
        } else {
            flipToBack()
        }
    }

    // MARK: restoreDeck

    public func restoreDeck() {
        if deckStatus != .none {
            return
        }

        deckStatus = .isRestoring

        if deckIsFlipped {
            let animation = Animation.linear(duration: kDurationAndDelay)

            withAnimation(animation) {
                self.deckFrontDegree = -90
            }

            withAnimation(animation.delay(kDurationAndDelay)) {
                deckBackDegree = 0
            } completion: {
//                self.items = self.choices.shuffled()
                self.deckIsFlipped = false
            }

//            withAnimation(.easeInOut(duration: 0.05).repeatCount(6).delay(2 * kDurationAndDelay)) {
//                enableWiggle.toggle()
//            } completion: {
//                self.enableWiggle = false
//
//                self.restoreAllStatus()
//                self.deckStatus = .none
//            }

        } else {
            withAnimation(.easeInOut(duration: 0.05).repeatCount(6)) {
                deckEnableWiggle.toggle()
            } completion: {
//                self.items = self.choices.shuffled()
//                self.enableWiggle = false

                self.restoreAllStatus()
                self.deckStatus = .none
            }
        }

//        tapCount += 1
    }

    // MARK: Private

    // MARK: restoreAllStatus

    private func restoreAllStatus() {
        deckStatus = .none
        deckIsFlipped = false
    }

    // MARK: flipToFront

    private func flipToFront() {
        updateCardText()
        SoundPlayer.shared.playFlipCardSound()

        let animation = Animation.linear(duration: kDurationAndDelay)

        withAnimation(animation) {
            deckBackDegree = 90
        }

        withAnimation(animation.delay(kDurationAndDelay)) {
            deckFrontDegree = 0
        } completion: {
            self.deckStatus = .none
        }
    }

    // MARK: updateCardText

    private func updateCardText() {
        let text = String(localized: "没有了，请按'还原'按钮")
        if let (choice, angle) = LotteryViewModel.select(from: items) {
            deckText = choice?.content ?? text
        } else {
            deckText = text
        }
    }

    // MARK: flipToBack

    private func flipToBack() {
        let animation = Animation.linear(duration: kDurationAndDelay)

        withAnimation(animation) {
            self.deckFrontDegree = -90
        }

        withAnimation(animation.delay(kDurationAndDelay)) {
            self.deckBackDegree = 0
        } completion: {
            self.deckStatus = .none
        }
    }
}

// MARK: GlobalViewModel + Choice

extension GlobalViewModel {
    var decisionDisplayMode: DecisionDisplayMode {
        selectedDecision?.displayModeEnum ?? .wheel
    }

    // MARK: setSelectedChoice

    func setSelectedChoice(_ choice: ChoiceItem?) {
        self.selectedChoice = choice

        if let choice {
            selectedChoice(choice)
        }
    }

    func setSelectedDecision(_ decision: Decision?) {
        self.selectedDecision = decision
    }

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
