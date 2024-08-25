//
//  MathCalculation.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/24.
//

import Foundation

struct Item: Identifiable {
    var id: Int {
        index
    }

    // 第几个数据
    let index: Int
    // 被抽中的权重
    let weight: CGFloat
    // 数据在转盘中的圆弧对应角度范围, 单位弧度制
    let startAngle: CGFloat
    let endAngle: CGFloat

    public func rectSize(innerRadius: CGFloat, outerRadius: CGFloat) -> CGSize {
        var alpha = endAngle - startAngle

        // 限制alpha的范围
        alpha = min(max(alpha, 0), .pi / 2)

        let halfHeight = innerRadius * tan(alpha / 2)

        // 计算width，并确保它不是负数
        let squaredDifference = max(outerRadius * outerRadius - halfHeight * halfHeight, 0)
        let width = sqrt(squaredDifference) - innerRadius

        // 使用max函数确保width和height都不小于0
        return CGSize(
            width: max(width, 0),
            height: max(2 * halfHeight, 0)
        )
    }

    var rotationDegrees: CGFloat {
        let avgAngle = (startAngle + endAngle) / 2
        return avgAngle - .pi / 2
    }
}

class MathCalculation {
    let innerRadius: CGFloat
    let outerRadius: CGFloat

    let weights: [CGFloat]

    init(innerRadius: CGFloat, outerRadius: CGFloat, weights: [CGFloat]) {
        self.innerRadius = innerRadius
        self.outerRadius = outerRadius
        self.weights = weights
        items = MathCalculation.calculateItemsByWeights(weights)
    }

    // 根据weights计算出每个weiht所在的比例
    var items: [Item]

    private static func calculateItemsByWeights(_ weights: [CGFloat]) -> [Item] {
        let totalWeight = weights.reduce(0, +)
        var startAngle: CGFloat = 0
        var calculatedItems: [Item] = []

        for (index, weight) in weights.enumerated() {
            let sweepAngle = (weight / totalWeight) * 2 * .pi
            let endAngle = startAngle + sweepAngle

            let item = Item(
                index: index,
                weight: weight,
                startAngle: startAngle,
                endAngle: endAngle
            )

            calculatedItems.append(item)
            startAngle = endAngle
        }

        return calculatedItems
    }
}
