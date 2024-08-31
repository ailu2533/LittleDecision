//
//  SpinWheel.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/31.
//

import Foundation
import SwiftUI

struct SpinWheel: View {
    let weights: [CGFloat]
    let titles: [String]
    let selected: [Bool]
    let radius: CGFloat
    let innerRadius: CGFloat
    let colors: [Color]
    let lineWidth: CGFloat
    let trailingPadding: CGFloat

    private let mcalc: MathCalculation

    init(weights: [CGFloat], titles: [String], selected: [Bool], radius: CGFloat, innerRadius: CGFloat, colors: [Color], lineWidth: CGFloat, trailingPadding: CGFloat) {
        self.weights = weights
        self.titles = titles
        self.selected = selected
        self.radius = radius
        self.innerRadius = innerRadius
        self.colors = colors
        self.lineWidth = lineWidth
        self.trailingPadding = trailingPadding
        mcalc = MathCalculation(innerRadius: innerRadius, outerRadius: radius, weights: weights, titles: titles, selected: selected)
    }

    var body: some View {
        ZStack {
            ForEach(mcalc.items) { item in
                SpinWheelCell(item: item,
                              colors: colors,
                              lineWidth: lineWidth,
                              innerRadius: innerRadius,
                              outerRadius: radius,
                              trailingPadding: trailingPadding
                )
            }
        }
    }
}
