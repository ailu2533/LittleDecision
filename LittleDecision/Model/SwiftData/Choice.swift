//
//  Choice.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/10/31.
//

import Foundation
import SwiftData

@Model
class Choice {
    // MARK: Lifecycle

    init(content: String, weight: Int = 1) {
        title = content
        self.weight = weight
        createDate = .now
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
    // 选中状态
    var choosed: Bool = false

    var weight4calc: Int {
//        let hideWeight = Defaults[.equalWeight]
//        return hideWeight ? 1 : weight
        return 1
    }
}

extension Choice: CustomStringConvertible {
    var description: String {
        """
        Choice: \(title)
        Weight: \(weight)
        """
    }
}
