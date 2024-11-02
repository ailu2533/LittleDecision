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
        subject
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

    private(set) var status: Status = .none

    // MARK: spin wheel prop

    private(set) var spinWheelTapCount = 0
    private(set) var spinWheelRotateAngle: Double = 0.0

    // MARK: deck

    private(set) var deckBackDegree: CGFloat = 0
    private(set) var deckFrontDegree: CGFloat = -90
    private(set) var deckIsFlipped = false
    private(set) var deckEnableWiggle: Bool = false
    private(set) var deckText: String = ""

    var choiceTitle: String {
        switch decisionDisplayMode {
        case .wheel:
            return selectedChoice?.content ?? ""
        case .stackedCards:
            return ""
        }
    }

    // MARK: restore

    func restore() {
        switch decisionDisplayMode {
        case .stackedCards:
            self.restoreDeck()
        case .wheel:
            self.restoreSpinWheel()
        }
    }

    // Mark refreshItems
    func refreshItems() {
        items = selectedDecision?.sortedChoices.map { ChoiceItem(choice: $0) } ?? []
    }

    // MARK: Private

    private let modelContext: ModelContext

    private let subject = CurrentValueSubject<ChangeAction, Never>(.decisionUUID(Defaults[.decisionID]))

    private var cancellables = Set<AnyCancellable>()
}

// MARK: GlobalViewModel + SpinWheel

extension GlobalViewModel {
    // MARK: startSpinning

    func startSpinning() {
        guard status == .none else { return }

        setSelectedChoice(nil)

        if let (choice, angle) = LotteryViewModel.select(from: items,noRepeat: Defaults[.noRepeat]) {
            let extraRotation = Defaults[.rotationTime] * 360.0
            let targetAngle = (270 - angle + 360 - spinWheelRotateAngle.truncatingRemainder(dividingBy: 360)) + extraRotation

            status = .isRunning

            withAnimation(.easeInOut(duration: 3)) {
                spinWheelRotateAngle += targetAngle

            } completion: { [weak self] in
                guard let self else { return }
                setSelectedChoice(choice)
                status = .none
            }
        } else {
            restoreSpinWheel()
            status = .none
        }
    }

    // MARK: restoreSpinWheel

    private func restoreSpinWheel() {
        guard status == .none else { return }

        status = .isRestoring

        selectedDecision?.unwrappedChoices.forEach { $0.enable = true }

        try? modelContext.save()

        selectedChoice = nil
        refreshItems()

        withAnimation {
            spinWheelRotateAngle -= spinWheelRotateAngle.truncatingRemainder(dividingBy: 360)
        } completion: { [weak self] in
            guard let self else { return }
            status = .none
            spinWheelRotateAngle = 0
        }
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

            refreshItems()

        case let .decisionUUID(decisionUUID):
            selectedDecision = fetchDecision(decisionID: decisionUUID)
            selectedChoice = nil
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

    private func selectedChoice(_ choice: ChoiceItem) {
        selectedDecision?.choices?.forEach({
            if $0.uuid == choice.uuid {
                $0.enable = false
            }
        })

        try? modelContext.save()

        refreshItems()
    }
}

// MARK: GlobalViewModel + Card

extension GlobalViewModel {
    // MARK: Public

    // MARK: flip

    public func flip() {
        guard status == .none else { return }

        status = .isRunning

        deckIsFlipped.toggle()

        if deckIsFlipped {
            flipToFront()
        } else {
            flipToBack()
        }
    }

    // MARK: restoreDeck

    public func restoreDeck() {
        guard status == .none else {
            return
        }

        status = .isRestoring

        if deckIsFlipped {
            let animation = Animation.linear(duration: kDurationAndDelay)

            withAnimation(animation) {
                self.deckFrontDegree = -90
            }

            withAnimation(animation.delay(kDurationAndDelay)) {
                deckBackDegree = 0
            } completion: {
                self.restoreDeckStatus()
            }

        } else {
            withAnimation(.easeInOut(duration: 0.05).repeatCount(6)) {
                deckEnableWiggle.toggle()
            } completion: {
                self.restoreDeckStatus()
            }
        }
    }

    // MARK: Private

    // MARK: restoreAllStatus

    private func restoreDeckStatus() {
        selectedDecision?.unwrappedChoices.forEach { $0.enable = true }

        try? modelContext.save()

        selectedChoice = nil
        refreshItems()
        status = .none
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
        } completion: { [weak self] in
            guard let self else { return }
            status = .none
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
        } completion: { [weak self] in
            guard let self else { return }
            status = .none
        }
    }

    // MARK: updateCardText

    private func updateCardText() {
        if let (choice, _) = LotteryViewModel.select(from: items,noRepeat: Defaults[.noRepeat]), let choice {
            deckText = choice.content
            setSelectedChoice(choice)
        } else {
            deckText = String(localized: "选项用完了，点击还原继续")
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
        decision.choices?.append(choice)
        try? modelContext.save()

        send(.decisionEdited(decision.uuid))
    }
}

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
