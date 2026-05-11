//
//  Choice.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/10/31.
//

import Defaults
import Foundation
import SwiftData

// MARK: - Choice

@Model
class Choice {
    // MARK: Lifecycle

    init(
        uuid: UUID = UUID(),
        content: String,
        weight: Int = 1,
        enable: Bool = true,
        createDate: Date = .now
    ) {
        self.uuid = uuid
        title = content
        self.weight = weight
        self.enable = enable
        self.createDate = createDate
    }

    // MARK: Internal

    var uuid: UUID = UUID()

    var decision: Decision?
    var title: String = "Untitled"
    var weight: Int = 1
//    var sortValue: Double

    // 是否可以被选中
    var enable: Bool = true

    var createDate: Date = Date()
}
