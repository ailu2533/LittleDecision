//
//  MathCalculation.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/24.
//

import Foundation
import UIKit

class MathCalculation {
    let innerRadius: CGFloat
    let outerRadius: CGFloat

    var rawItems: [SpinCellItem]

    init(innerRadius: CGFloat, outerRadius: CGFloat, rawItems: [SpinCellItem]) {
        self.innerRadius = innerRadius
        self.outerRadius = outerRadius
        self.rawItems = rawItems
    }

    func calculateItemsByWeights(_ weights: [CGFloat]) async -> [Item] {
        return await Task.detached(priority: .userInitiated) {
            var calculatedItems: [Item] = []
            let totalWeight = weights.reduce(0, +)
            var startAngle: CGFloat = 0

            for (index, rawItem) in self.rawItems.enumerated() {
                let sweepAngle = (rawItem.weight / totalWeight) * 2 * .pi
                let endAngle = startAngle + sweepAngle

                let item = Item(
                    index: index,
                    weight: rawItem.weight,
                    title: rawItem.title,
                    enabled: rawItem.enabled,
                    startAngle: startAngle,
                    endAngle: endAngle
                )

                calculatedItems.append(item)
                startAngle = endAngle
            }

            return calculatedItems
        }.value
    }
}
