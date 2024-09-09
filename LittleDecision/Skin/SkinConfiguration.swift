//
//  SkinConfiguration.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/1.
//

import Defaults
import Foundation

enum SkinKind: String, Codable, Defaults.Serializable, CaseIterable, Identifiable {
    case pinkBlue, pinkWhite, blue

    var id: String {
        rawValue
    }
}

struct SkinManager {
    public static let shared = SkinManager()

    private init() {}

    public func getSkinConfiguration(skinKind: SkinKind) -> SpinWheelConfiguration {
        configurations[skinKind] ?? configurations[.pinkBlue]!
    }

    let configurations: [SkinKind: SpinWheelConfiguration] = [
        .pinkBlue: SpinWheelConfiguration(
            skinKind: .pinkBlue,
            fills: [
                .radialGradient(colors: [.pink1, .white], center: .center, startRadius: 0, endRadiusRatio: 1),
                .solidFill(.white)
            ],
            isPremium: false
        ),
        .pinkWhite: SpinWheelConfiguration(
            skinKind: .pinkWhite,
            fills: [.radialGradient(colors: [.pink1, .pink2], center: .center, startRadius: 0, endRadiusRatio: 1)],
            isPremium: true
        ),
        .blue: SpinWheelConfiguration(
            skinKind: .blue,
            fills: [.radialGradient(colors: [.blue1, .blue2], center: .center, startRadius: 0, endRadiusRatio: 1)],
            isPremium: true
        ),
    ]
}


