//
//  ChartOverlay.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/25.
//

import Charts
import Foundation
import SwiftUI

struct ChartOverlayView: View {
    let currentDecision: Decision
    var selection: Choice?

    let size: CGFloat
    let innerRadius: CGFloat
    let outerRadius: CGFloat
    let mcalc: MathCalculation

    init(proxy: ChartProxy, currentDecision: Decision, selection: Choice? = nil) {
        size = min(proxy.plotSize.width, proxy.plotSize.height)
        self.currentDecision = currentDecision
        self.selection = selection
        outerRadius = (size / 2).rounded()
        innerRadius = 60

        let weights = currentDecision.sortedChoices.map { CGFloat($0.weight) }

        mcalc = MathCalculation(
            innerRadius: innerRadius,
            outerRadius: outerRadius,
            weights: weights
        )

        Logging.shared.debug("ChartOverlayView init")
    }

    var body: some View {
        ForEach(Array(zip(mcalc.items, currentDecision.sortedChoices)), id: \.0.id) { item, choice in
            ChartItemView(item: item, choice: choice, innerRadius: innerRadius, outerRadius: outerRadius)
        }
    }
}

struct ChartItemView: View {
    let item: Item
    let choice: Choice
    let innerRadius: CGFloat
    let outerRadius: CGFloat
    let size: CGSize

    init(item: Item, choice: Choice, innerRadius: CGFloat, outerRadius: CGFloat) {
        self.item = item
        self.choice = choice
        self.innerRadius = innerRadius
        self.outerRadius = outerRadius
        size = item.rectSize(innerRadius: innerRadius, outerRadius: outerRadius)
    }

    var body: some View {
        Text(choice.title)
            .padding(.trailing, 16)
            .frame(
                width: min(size.width, .greatestFiniteMagnitude),
                height: min(size.height, .greatestFiniteMagnitude),
                alignment: .trailing
            )
            .font(.system(size: 18, weight: .semibold))
            .minimumScaleFactor(0.1)
            .multilineTextAlignment(.trailing)
            .lineLimit(3)
            .offset(x: innerRadius + size.width / 2)
            .rotationEffect(.radians(item.rotationDegrees))
            .foregroundColor(choice.choosed ? .white : .black)
    }
}
