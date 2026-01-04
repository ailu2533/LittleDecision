//
//  Defaults.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/13.
//

import Defaults
import Foundation
import SpinWheel
import SwiftUI

extension Defaults.Keys {
    static let noRepeat = Key<Bool>("noRepeat", default: false)
    static let equalWeight = Key<Bool>("equalWeight", default: false)
    static let rotationTime = Key<Double>("rotationTime", default: 2)
    static let enableSound = Key<Bool>("enableSound", default: false)

    static let hasData = Key<Bool>("hasData", default: false, iCloud: true)
    static let decisionID = Key<UUID>("decisionId", default: UUID())

//    static let fontSize = Key<CGFloat>("fontSize", default: 15)
//
//    static let selectedThemeID = Key<ThemeID>("selectedThemeID", default: .pink)
//
//    static let selectedConfigurationID = Key<UUID?>("selectedConfigurationID", default: nil)

    static let selectedSkinConfiguration = Key<SkinKind>("selectedSkinConfiguration", default: .pinkBlue)
}

extension Defaults.Keys {
//    /// An identifier for the three-step process the person completes before this app chooses to request a review.
//    @AppStorage("processCompletedCount") var processCompletedCount = 0
//
//    /// The most recent app version that prompts for a review.
//    @AppStorage("lastVersionPromptedForReview") var lastVersionPromptedForReview = ""

//    static let processCompletedCount = Key<Int>("processCompletedCount", default: 0)
//    static let lastVersionPromptedForReview = Key<String>("lastVersionPromptedForReview", default: "")
}
