//
//  CardViewModel.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/10/1.
//

import Foundation
import SwiftUI

// MARK: - DeckStatus

enum DeckStatus: String {
    case isFlipping
    case isRestoring
    case none
}

// MARK: - CardViewModel

@Observable
class CardViewModel {
    // MARK: Lifecycle

    init(items: [ChoiceItem], noRepeat: Bool) {
//        self.items = items
//        choices = items
//        self.noRepeat = noRepeat
    }

 
}

//    private func drawWeightedItem() -> ChoiceItem? {
//        let weightedItems = items
//
//        guard !weightedItems.isEmpty else {
//            return nil
//        }
//
//        Logging.shared.debug("drawWeightedItem \(weightedItems.count) \(weightedItems)")
//
//        let totalWeight = weightedItems.reduce(0) { $0 + $1.weight }
//        let randomNumber = Int.random(in: 1 ... totalWeight)
//
//        var accumulatedWeight = 0
//        for item in weightedItems {
//            accumulatedWeight += item.weight
//            if randomNumber <= accumulatedWeight {
//                return item
//            }
//        }
//
//        return weightedItems.last
//    }
//
//    private func draw() -> ChoiceItem? {
//        if let item = drawWeightedItem() {
//            if noRepeat {
//                items.removeAll {
//                    $0.id == item.id
//                }
//            }
//
//            return item
//        }
//
//        return nil
//    }
