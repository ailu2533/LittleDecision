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
                ChartItemTextView(
                    item: item,
                    size: size,
                    innerRadius: innerRadius,
                    customBodyFont: customBodyFont
                )
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


