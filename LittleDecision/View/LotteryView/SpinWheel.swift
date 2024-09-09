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

    init(rawItems: [SpinCellRawItem], size: CGSize, configuration: SpinWheelConfiguration) {
        self.rawItems = rawItems
        self.size = size
        self.configuration = configuration

        radius = configuration.radius(size: size)
        innerRadius = configuration.innerRadius(size: size)
        trailingPadding = configuration.trailingPadding(size: size)

        mcalc = MathCalculation(innerRadius: innerRadius, outerRadius: radius, rawItems: rawItems)
    }

    var body: some View {
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

        .task {
            items = await mcalc.calculateItemsByWeights(mcalc.rawItems.map({ $0.weight }))
        }
    }
}

struct SpinCellRawItem: Identifiable {
    let id = UUID()
    let title: String
    let weight: CGFloat
    let enabled: Bool

    init(title: String, weight: CGFloat = 1, enabled: Bool = true) {
        self.title = title
        self.weight = weight
        self.enabled = enabled
    }
}
