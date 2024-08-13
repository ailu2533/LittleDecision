//
//  Defaults.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/13.
//

import Defaults
import Foundation

extension Defaults.Keys {
    static let noRepeat = Key<Bool>("noRepeat", default: false)
    static let equalWeight = Key<Bool>("equalWeight", default: false)
    static let rotationTime = Key<Double>("rotationTime", default: 4)
}
