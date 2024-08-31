//
//  SpinWheelCell.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/31.
//

import Foundation
import SwiftUI

struct SpinWheelCell: View {
    let item: Item
    let colors: [Color]
    let lineWidth: CGFloat
    let innerRadius: CGFloat
    let outerRadius: CGFloat
    let trailingPadding: CGFloat

    var linearG: RadialGradient {
        RadialGradient(
            gradient: Gradient(colors: [.pink1, .white]),
            center: .center,
            startRadius: 0,
            endRadius: outerRadius
        )
    }

    var body: some View {
        SpinWheelCellShape(startAngle: .radians(item.startAngle), endAngle: .radians(item.endAngle))
            .fill(item.index % 2 == 0 ? linearG : .radialGradient(.init(colors: [Color.white]), center: .center, startRadius: 0, endRadius: outerRadius))
            .stroke(Color.black, style: .init(lineWidth: lineWidth, lineJoin: .round))
            .overlay {
                ChartItemText(item: item, selected: false, innerRadius: innerRadius, outerRadius: outerRadius, trailingPadding: trailingPadding)
            }
    }
}
