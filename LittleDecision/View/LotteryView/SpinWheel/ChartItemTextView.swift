//
//  ChartItemTextView.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/16.
//

import Defaults
import Foundation
import SwiftUI

struct ChartItemTextView: View {
    let item: Item
    let size: CGSize
    let innerRadius: CGFloat
    let customBodyFont: Font

    @Default(.noRepeat)
    private var noRepeat

    var fontColor: Color {
        if noRepeat {
            return item.enabled ? Color(.black) : Color(.gray)
        }

        return Color(.black)
    }

    var body: some View {
        Text(item.title)
            .font(customBodyFont)
            .foregroundStyle(fontColor)
            .multilineTextAlignment(.trailing)
            .minimumScaleFactor(0.5)
            .lineLimit(3)
            .frame(width: size.width, height: size.height, alignment: .trailing)
            .offset(x: innerRadius + size.width / 2)
            .rotationEffect(.radians(item.rotationDegrees))
    }
}
