//
//  ChartItemText.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/31.
//

import SwiftUI

struct ChartItemText: View {
    let item: Item
    let selected: Bool
    let innerRadius: CGFloat
    let outerRadius: CGFloat
    let trailingPadding: CGFloat

    var body: some View {
        let size = item.rectSize(innerRadius: innerRadius, outerRadius: outerRadius)
        return Text(item.title)
            .font(customBodyFont)
            .foregroundStyle(selected ? Color.black : Color.gray)
            .padding(.trailing, 12)
            .multilineTextAlignment(.trailing)
            .minimumScaleFactor(0.3)
            .lineLimit(3)
            .frame(width: size.width, height: size.height, alignment: .trailing)
            .offset(x: innerRadius + size.width / 2)
            .rotationEffect(.radians(item.rotationDegrees))
    }
}
