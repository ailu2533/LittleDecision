//
//  MathCalculation.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/24.
//

import Foundation

struct Item: Identifiable {
    let id: Int
    let weight: CGFloat
    let startAngle: CGFloat
    let endAngle: CGFloat

    private static let cache = NSCache<NSString, NSValue>()

    var rotationDegrees: CGFloat {
        (startAngle + endAngle) / 2 - .pi / 2
    }

    func rectSize(innerRadius: CGFloat, outerRadius: CGFloat) -> CGSize {
        let cacheKey = NSString(string: "\(id),\(startAngle),\(endAngle),\(innerRadius),\(outerRadius)")

        if let cachedSize = Item.cache.object(forKey: cacheKey) {
            return cachedSize.cgSizeValue
        }

        let alpha = min(endAngle - startAngle, .pi / 2)
        let halfHeight = innerRadius * tan(alpha / 2)
        let width = sqrt(pow(outerRadius, 2) - pow(halfHeight, 2)) - innerRadius
        let size = CGSize(width: max(0, width), height: max(0, 2 * halfHeight))

        Item.cache.setObject(NSValue(cgSize: size), forKey: cacheKey)
        return size
    }

    static func clearCache() {
        cache.removeAllObjects()
    }
}

final class MathCalculation {
    let innerRadius: CGFloat
    let outerRadius: CGFloat
    let weights: [CGFloat]
    let items: [Item]

    private static let cache = NSCache<NSString, NSArray>()

    init(innerRadius: CGFloat, outerRadius: CGFloat, weights: [CGFloat]) {
        self.innerRadius = max(0, innerRadius)
        self.outerRadius = max(self.innerRadius, outerRadius)
        self.weights = weights.map { max(0, $0) }

        let cacheKey = NSString(string: "\(self.innerRadius),\(self.outerRadius),\(self.weights)")
        if let cachedItems = MathCalculation.cache.object(forKey: cacheKey) as? [Item] {
            items = cachedItems
        } else {
            let calculatedItems = MathCalculation.calculateItemsByWeights(self.weights)
            MathCalculation.cache.setObject(calculatedItems as NSArray, forKey: cacheKey)
            items = calculatedItems
        }
    }

    private static func calculateItemsByWeights(_ weights: [CGFloat]) -> [Item] {
        let totalWeight = weights.reduce(0, +)
        guard totalWeight > 0 else { return [] }

        var startAngle: CGFloat = 0
        return weights.enumerated().map { index, weight in
            let sweepAngle = (weight / totalWeight) * 2 * .pi
            let endAngle = startAngle + sweepAngle
            defer { startAngle = endAngle }
            return Item(id: index, weight: weight, startAngle: startAngle, endAngle: endAngle)
        }
    }

    static func clearCache() {
        cache.removeAllObjects()
    }
}
