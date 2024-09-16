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
    case pink, pastel, neon, monochromeBlue
    var id: String { rawValue }
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
        case .monochromeBlue:
            return .monochromeBlue
        }
    }
}

