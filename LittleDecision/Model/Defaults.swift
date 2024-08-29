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
    static let rotationTime = Key<Double>("rotationTime", default: 4)
    static let enableSound = Key<Bool>("enableSound", default: false)

    static let hasData = Key<Bool>("hasData", default: false)
    static let decisionId = Key<UUID>("decisionId", default: UUID())

    static let fontSize = Key<CGFloat>("fontSize", default: 15)
}
