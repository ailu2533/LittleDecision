//
//  SectionFill.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/16.
//

import Foundation
import SwiftUI

enum SectionFill {
    case radialGradient(colors: [Color], center: UnitPoint = .center, startRadius: CGFloat = 0, endRadiusRatio: CGFloat = 1)
    case linearGradient(colors: [Color], startPoint: UnitPoint = .top, endPoint: UnitPoint = .bottom)
    case solidFill(Color)

    func gradient(in radius: CGFloat?) -> AnyShapeStyle {
        switch self {
        case let .radialGradient(colors, center, startRadius, endRadiusRatio):
            if let radius {
                let endRadius = radius * endRadiusRatio
                return AnyShapeStyle(RadialGradient(colors: colors, center: center, startRadius: startRadius, endRadius: endRadius))
            }
            return AnyShapeStyle(colors[0])

        case let .linearGradient(colors, startPoint, endPoint):
            return AnyShapeStyle(LinearGradient(colors: colors, startPoint: startPoint, endPoint: endPoint))
        case let .solidFill(color):
            return AnyShapeStyle(color)
        }
    }
}
