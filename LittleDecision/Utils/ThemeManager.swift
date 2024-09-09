//
//  ThemeManager.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/29.
//

import Defaults
import Foundation
import SwiftUI

enum ThemeID: String, CaseIterable, Identifiable, Codable, Defaults.Serializable {
    case pink, pastel, neon, monochrome
    var id: String { rawValue }
}

struct WheelTheme: Identifiable {
    let id: ThemeID
    let sectorFillStyles: [SectionFill]
    let pointerView: any View
    let outerColor: Color
}

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

@Observable
class ThemeManager {
    var selectedThemeID: ThemeID {
        get {
            if let storedThemeID = UserDefaults.standard.string(forKey: "selectedThemeID"),
               let themeID = ThemeID(rawValue: storedThemeID) {
                return themeID
            }
            return .pink // 默认主题
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "selectedThemeID")
        }
    }

    var currentTheme: WheelTheme {
        switch selectedThemeID {
        case .pink:
            return .pink
        case .pastel:
            return .pastel
        case .neon:
            return .neon
        case .monochrome:
            return .monochrome
        }
    }
}

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
        id: .pink,
        sectorFillStyles: [
            SectionFill.radialGradient(colors: [.pink1, .white], center: .center, startRadius: 0, endRadiusRatio: 1),
            SectionFill.solidFill(.white),
        ],
        pointerView: AnyView(PointerView()),
        outerColor: .pink1
    )
    static let neon = WheelTheme(
        id: .pink,
        sectorFillStyles: [
            SectionFill.radialGradient(colors: [.pink1, .white], center: .center, startRadius: 0, endRadiusRatio: 1),
            SectionFill.solidFill(.white),
        ],
        pointerView: AnyView(PointerView()),
        outerColor: .pink1
    )
    static let monochrome = WheelTheme(
        id: .pink,
        sectorFillStyles: [
            SectionFill.radialGradient(colors: [.pink1, .white], center: .center, startRadius: 0, endRadiusRatio: 1),
            SectionFill.solidFill(.white),
        ],
        pointerView: AnyView(PointerView()),
        outerColor: .pink1
    )
}
