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

    var body: some View {
        Group {
            if let size {
                Text(item.title)
                    .font(customBodyFont)
                    .foregroundStyle(item.enabled ? Color(.black) : Color(.gray))
//                    .padding(.trailing, trailingPadding)
                    .multilineTextAlignment(.trailing)
                    .minimumScaleFactor(0.5)
                    .lineLimit(3)
//                    .background(.blue)
                    .frame(width: size.width, height: size.height, alignment: .trailing)
                    .offset(x: innerRadius + size.width / 2)
                    .rotationEffect(.radians(item.rotationDegrees))
            } else {
                Text(verbatim: "")
            }
        }
        .task {
            size = await Task {
                item.rectSize(innerRadius: innerRadius, outerRadius: outerRadius - trailingPadding)
            }.value
        }
    }
}
