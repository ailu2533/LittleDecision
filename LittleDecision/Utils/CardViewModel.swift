//
//  CardViewModel.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/10/1.
//

import Foundation
import SwiftUI

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

    private var items: [CardChoiceItem]
    private var choices: [CardChoiceItem]

    private let noRepeat: Bool

    init(items: [CardChoiceItem], noRepeat: Bool) {
        self.items = items
        choices = items
        self.noRepeat = noRepeat
    }

//    @ObservationIgnored
    private var isFliping = false

    private(set) var tapCount = 0

    public func flip() {
        if isFliping {
            return
        }

        isFliping = true

        tapCount += 1
        isFlipped.toggle()

        if isFlipped {
            flipToFront()
        } else {
            flipToBack()
        }
    }

    public func restore() {
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
            }

        } else {
            withAnimation(.easeInOut(duration: 0.05).repeatCount(6)) {
                enableWiggle.toggle()
            } completion: {
                self.enableWiggle = false
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
        } completion: {
            if !self.items.isEmpty {
                if let item = self.draw2() {
                    self.text = item.content
                } else {
                    self.text = String(localized: "未知错误")
                }

            } else {
                self.text = String(localized: "没有了，请按\"还原\"按钮")
            }
        }

        withAnimation(animation.delay(scaleDurationAndDelay)) {
            backDegree = 90
        }

        withAnimation(animation.delay(scaleDurationAndDelay * 2)) {
            frontDegree = 0
        } completion: {
            self.isFliping = false
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

            self.isFliping = false
        }
    }

    private func drawWeightedItem() -> CardChoiceItem? {
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

    public func draw2() -> CardChoiceItem? {
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
