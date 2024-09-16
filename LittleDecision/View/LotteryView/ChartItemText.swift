//
//  ChartItemText.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/31.
//

import SwiftUI

struct ChartItemText: View {
    let item: Item
    let innerRadius: CGFloat
    let outerRadius: CGFloat
    let trailingPadding: CGFloat

    @State private var size: CGSize?

    init(item: Item, innerRadius: CGFloat, outerRadius: CGFloat, trailingPadding: CGFloat) {
        self.item = item
        self.innerRadius = innerRadius
        self.outerRadius = outerRadius
        self.trailingPadding = trailingPadding
        Logging.shared.debug("ChartItemText init")
    }

    var body: some View {
        let _ = Self._printChanges()

        Group {
            if let size {
                Text(item.title)
                    .font(customBodyFont)
                    .foregroundStyle(item.enabled ? Color(.black) : Color(.gray))
                    .multilineTextAlignment(.trailing)
                    .minimumScaleFactor(0.5)
                    .lineLimit(3)
                    .frame(width: size.width, height: size.height, alignment: .trailing)
                    .offset(x: innerRadius + size.width / 2)
                    .rotationEffect(.radians(item.rotationDegrees))
            } else {
                Text(verbatim: "")
            }
        }
        .task(id: item) {
            size = await Task {
                item.rectSize(innerRadius: innerRadius, outerRadius: outerRadius - trailingPadding)
            }.value
        }
    }
}
