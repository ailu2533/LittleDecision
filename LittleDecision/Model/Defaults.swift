//
//  Defaults.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/13.
//

import Defaults
import Foundation
import SwiftUI

extension Defaults.Keys {
    static let noRepeat = Key<Bool>("noRepeat", default: false)
    static let equalWeight = Key<Bool>("equalWeight", default: false)
    static let rotationTime = Key<Double>("rotationTime", default: 2)
    static let enableSound = Key<Bool>("enableSound", default: false)

    static let hasData = Key<Bool>("hasData", default: false)
    static let decisionId = Key<UUID>("decisionId", default: UUID())

    static let fontSize = Key<CGFloat>("fontSize", default: 15)

    static let selectedThemeID = Key<ThemeID>("selectedThemeID", default: .pink)

    static let selectedConfigurationID = Key<UUID?>("selectedConfigurationID", default: nil)

    static let selectedSkinConfiguration = Key<SkinKind>("selectedSkinConfiguration", default: .pinkBlue)

    // 决策展示模式：转盘或堆叠卡片
    static let decisionDisplayMode = Key<DecisionDisplayMode>("decisionDisplayMode", default: .wheel)
}
