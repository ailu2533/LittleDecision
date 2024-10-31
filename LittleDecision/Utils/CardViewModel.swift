//
//  CardViewModel.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/10/1.
//

import Foundation
import SwiftUI

enum DeckStatus: String {
    case isFlipping
    case isRestoring
    case none
}

@Observable
class CardViewModel {
    private(set) var backDegree: CGFloat = 0
    private(set) var frontDegree: CGFloat = -90

    private(set) var isScaled = false
    private(set) var isFlipped = false
    private(set) var xOffset: CGFloat = 0
    private(set) var enableWiggle: Bool = false

    private(set) var showMask: Bool = false
    private(set) var text: String = ""

    private(set) var items: [ChoiceItem]
    private let choices: [ChoiceItem]

    private let noRepeat: Bool

    var deckStatus: DeckStatus = .none

    init(items: [ChoiceItem], noRepeat: Bool) {
        self.items = items
        choices = items
        self.noRepeat = noRepeat
    }

//    @ObservationIgnored
//    var isFliping = false
//    var isRestoring = false

    private func restoreAllStatus() {
        deckStatus = .none
//        showMask = false
//        xOffset = 0
//        isScaled = false
        isFlipped = false
//        enableWiggle = false
    }

    private(set) var tapCount = 0

    public func flip() {
        if deckStatus != .none {
            return
        }

        deckStatus = .isFlipping

        tapCount += 1
        isFlipped.toggle()

        if isFlipped {
            flipToFront()
        } else {
            flipToBack()
        }
    }

    public func restore() {
        if deckStatus != .none {
            return
        }

        deckStatus = .isRestoring

        if isFlipped {
            let animation = Animation.linear(duration: scaleDurationAndDelay)

            withAnimation(animation) {
                self.isScaled = false
                self.xOffset = .zero

                self.frontDegree = -90
            }

            withAnimation(animation.delay(scaleDurationAndDelay)) {
                backDegree = 0
            } completion: {
                self.items = self.choices.shuffled()
                self.isFlipped = false
            }

            withAnimation(.easeInOut(duration: 0.05).repeatCount(6).delay(2 * scaleDurationAndDelay)) {
                enableWiggle.toggle()
            } completion: {
                self.enableWiggle = false

                self.restoreAllStatus()
                self.deckStatus = .none
            }

        } else {
            withAnimation(.easeInOut(duration: 0.05).repeatCount(6)) {
                enableWiggle.toggle()
            } completion: {
                self.items = self.choices.shuffled()
                self.enableWiggle = false

                self.restoreAllStatus()
                self.deckStatus = .none
            }
        }

        tapCount += 1
    }

    private func flipToFront() {
        let animation = Animation.linear(duration: scaleDurationAndDelay)

        SoundPlayer.shared.playFlipCardSound()

        withAnimation(animation) {
            showMask = true
            isScaled = true
        } completion: { [self] in
            updateCardText()
        }

        withAnimation(animation.delay(scaleDurationAndDelay)) {
            backDegree = 90
        }

        withAnimation(animation.delay(scaleDurationAndDelay * 2)) {
            frontDegree = 0
        } completion: {
            self.deckStatus = .none
        }
    }

    private func updateCardText() {
        if !items.isEmpty {
            text = draw()?.content ?? String(localized: "未知错误")
        } else {
            text = String(localized: "没有了，请按\"还原\"按钮")
        }
    }

    private func flipToBack() {
        let animation = Animation.linear(duration: durationAndDelay)

        withAnimation(animation) {
            xOffset = kXOffset
        }

        withAnimation(animation.delay(durationAndDelay)) {
            showMask = false
        } completion: {
            self.isScaled = false
            self.backDegree = 0
            self.frontDegree = -90
            self.xOffset = .zero

            self.deckStatus = .none
        }
    }

    private func drawWeightedItem() -> ChoiceItem? {
        let weightedItems = items

        guard !weightedItems.isEmpty else {
            return nil
        }

        Logging.shared.debug("drawWeightedItem \(weightedItems.count) \(weightedItems)")

        let totalWeight = weightedItems.reduce(0) { $0 + $1.weight }
        let randomNumber = Int.random(in: 1 ... totalWeight)

        var accumulatedWeight = 0
        for item in weightedItems {
            accumulatedWeight += item.weight
            if randomNumber <= accumulatedWeight {
                return item
            }
        }

        return weightedItems.last
    }

    private func draw() -> ChoiceItem? {
        if let item = drawWeightedItem() {
            if noRepeat {
                items.removeAll {
                    $0.id == item.id
                }
            }

            return item
        }

        return nil
    }
}
