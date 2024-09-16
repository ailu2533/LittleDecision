//
//  SpinWheel.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/31.
//

import Foundation
import SwiftUI

struct SpinWheel: View {
    private let radius: CGFloat
    private let innerRadius: CGFloat
    private let trailingPadding: CGFloat

    let size: CGSize
    let rawItems: [SpinCellRawItem]
    let configuration: SpinWheelConfiguration

    private let mcalc: MathCalculation

    @State private var items: [Item] = []

    init(rawItems: [SpinCellRawItem],
         size: CGSize,
         configuration: SpinWheelConfiguration) {
        self.rawItems = rawItems
        self.size = size
        self.configuration = configuration

        radius = configuration.radius(size: size)
        innerRadius = configuration.innerRadius(size: size)
        trailingPadding = configuration.trailingPadding(size: size)

        mcalc = MathCalculation(innerRadius: innerRadius, outerRadius: radius, rawItems: rawItems)

        Logging.shared.debug("SpinWheel init \(rawItems)")
    }

    var body: some View {
        let _ = Self._printChanges()

        ZStack {
            ForEach(items) { item in
                SpinWheelCell(item: item,
                              innerRadius: innerRadius,
                              outerRadius: radius,
                              trailingPadding: trailingPadding,
                              configuration: configuration
                )
            }
        }
        .task(id: rawItems.hashValue) {
            items = await mcalc.calculateItemsByWeights(mcalc.rawItems.map({ $0.weight }))
            Logging.shared.debug("SpinWheel task items \(items)")

        }
    }
}

// 首先确保 SpinCellRawItem 遵循 Hashable 协议
extension SpinCellRawItem: Hashable {
    public func hash(into hasher: inout Hasher) {
        // 根据 SpinCellRawItem 的属性来实现哈希函数
        // 这里假设 SpinCellRawItem 有 id 和 weight 属性
        hasher.combine(id)
        hasher.combine(weight)
        hasher.combine(enabled)
    }

    public static func == (lhs: SpinCellRawItem, rhs: SpinCellRawItem) -> Bool {
        // 实现相等性比较
        // 这里假设两个 SpinCellRawItem 的 id 相同就认为它们相等
        return lhs.id == rhs.id &&
            lhs.weight == rhs.weight &&
            lhs.enabled == rhs.enabled
    }
}
