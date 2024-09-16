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
    let innerRadius: CGFloat
    let outerRadius: CGFloat
    let trailingPadding: CGFloat
    let configuration: SpinWheelConfiguration
    
    init(item: Item, innerRadius: CGFloat, outerRadius: CGFloat, trailingPadding: CGFloat, configuration: SpinWheelConfiguration) {
        self.item = item
        self.innerRadius = innerRadius
        self.outerRadius = outerRadius
        self.trailingPadding = trailingPadding
        self.configuration = configuration
        
        Logging.shared.debug("SpinWheelCell init \(item)")
        
    }

    var body: some View {
        let _ = Self._printChanges()
        let fills = configuration.fills
        SpinWheelCellShape(startAngle: .radians(item.startAngle),
                           endAngle: .radians(item.endAngle)
        )
        .fill(fills[item.index % fills.count].gradient(in: outerRadius))
        .stroke(Color.black,
                style: .init(lineWidth: configuration.cellLineWidth, lineJoin: .round)
        )
        .overlay {
            ChartItemText(item: item, innerRadius: innerRadius, outerRadius: outerRadius, trailingPadding: trailingPadding)
        }
    }
}
