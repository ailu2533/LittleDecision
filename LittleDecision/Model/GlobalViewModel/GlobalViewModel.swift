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

@MainActor
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

    // MARK: Public

    public func send(_ action: ChangeAction) {
        subject.send(action)
    }

    // MARK: restore

    public func restore() {
        switch decisionDisplayMode {
        case .stackedCards:
            self.restoreDeck()
        case .wheel:
            self.restoreSpinWheel()
        }
    }

    public func go() {
        switch decisionDisplayMode {
        case .stackedCards:
            self.flip()
        case .wheel:
            self.startSpinning()
        }
    }

    // MARK: Internal

    // 每次变化时，selectedChoice整体变化
    var selectedChoice: ChoiceItem?
    var selectedDecision: Decision?

    private(set) var items: [ChoiceItem] = []

    var status: Status = .none

    // MARK: spin wheel prop

    var spinWheelRotateAngle: Double = 0.0

    // MARK: deck

    var deckBackDegree: CGFloat = 0
    var deckFrontDegree: CGFloat = -90
    var deckIsFlipped = false
    var deckEnableWiggle: Bool = false

    let modelContext: ModelContext

    var choiceTitle: String {
        switch decisionDisplayMode {
        case .wheel:
            return selectedChoice?.content ?? ""
        case .stackedCards:
            return ""
        }
    }

    // Mark refreshItems
    func refreshItems() {
        items = selectedDecision?.sortedChoices.map { ChoiceItem(choice: $0) } ?? []
    }

    // MARK: Private

    private let subject = PassthroughSubject<ChangeAction, Never>()

    private var cancellables = Set<AnyCancellable>()
}
