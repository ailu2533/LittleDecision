//
//  DeckCard.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/11/15.
//
import Defaults
import SwiftUI

// MARK: GlobalViewModel + Card

extension GlobalViewModel {
    // MARK: Public

    // MARK: flip

    public func flip() {
        guard status == .none else {
            return
        }

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
            deckEnableWiggle = true
            withAnimation(.easeInOut(duration: 0.05).repeatCount(6)) {
                deckEnableWiggle = false
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
            // 不需要手动停止
//            SoundPlayer.shared.stopFilpCardSound()
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
        if let (choice, _) = LotteryViewModel.select(from: items, noRepeat: Defaults[.noRepeat]), let choice {
            setSelectedChoice(choice)
        } else {
            setSelectedChoice(nil)
        }
    }
}
