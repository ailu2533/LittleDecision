//
//  WheelTheme.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/16.
//

import Foundation
import SwiftUI

extension WheelTheme {
    static let pink = WheelTheme(
        id: .pink,
        sectorFillStyles: [
            SectionFill.radialGradient(colors: [.pink1, .white], center: .center, startRadius: 0, endRadiusRatio: 1),
            SectionFill.solidFill(.white),
        ],
        pointerView: AnyView(PointerView()),
        outerColor: .pink1
    )

    // 定义其他主题...
    static let pastel = WheelTheme(
        id: .pastel,
        sectorFillStyles: [
            SectionFill.radialGradient(colors: [.pink1, .white], center: .center, startRadius: 0, endRadiusRatio: 1),
            SectionFill.solidFill(.white),
        ],
        pointerView: AnyView(PointerView()),
        outerColor: .pink1
    )
    static let neon = WheelTheme(
        id: .neon,
        sectorFillStyles: [
            SectionFill.radialGradient(colors: [.pink1, .white], center: .center, startRadius: 0, endRadiusRatio: 1),
            SectionFill.solidFill(.white),
        ],
        pointerView: AnyView(PointerView()),
        outerColor: .pink1
    )
    static let monochromeBlue = WheelTheme(
        id: .monochromeBlue,
        sectorFillStyles: [
            SectionFill.radialGradient(colors: [.pink1, .white], center: .center, startRadius: 0, endRadiusRatio: 1),
            SectionFill.solidFill(.white),
        ],
        pointerView: AnyView(PointerView()),
        outerColor: .pink1
    )
}

extension WheelTheme {
    static let `default` = WheelTheme(
        id: .pink,
        sectorFillStyles: [
            SectionFill.radialGradient(colors: [.pink1, .white], center: .center, startRadius: 0, endRadiusRatio: 1),
            SectionFill.solidFill(.white),
        ],
        pointerView: AnyView(PointerView()),
        outerColor: .pink1
    )
}
