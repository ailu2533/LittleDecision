//
//  Model.swift
//  LittleDecision
//
//  Created by ailu on 2024/4/3.
//

import Defaults
import SwiftData
import SwiftUI

@Model
class Decision {
    let uuid: UUID
    var title: String

    @Relationship(inverse: \Choice.decision)
    var choices: [Choice]

    // 已经保存
    var saved: Bool = false

    var displayModel: Int = DecisionDisplayMode.wheel.rawValue

    var createDate: Date
    var updateDate: Date

    @Transient
    var wheelVersion: Int = 0

    init(uuid: UUID = UUID(), title: String, choices: [Choice], saved: Bool = false) {
        self.uuid = uuid
        self.title = title
        self.choices = choices
        self.saved = saved
        createDate = .now
        updateDate = .now
    }

    var sortedChoices: [Choice] {
        let res = choices.sorted(by: {
            if $0.createDate == $1.createDate {
                return $0.uuid < $1.uuid
            }
            return $0.createDate < $1.createDate
        })

//        Logging.shared.debug("sorted \(res)")

        return res
    }

    // 总权重
    var totalWeight: Int {
        return choices.reduce(0) { partialResult, choice in
            partialResult + choice.weight
        }
    }
}

extension Decision {
    var displayModeEnum: DecisionDisplayMode {
        return .init(rawValue: displayModel) ?? .wheel
    }
}

extension Decision: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
        hasher.combine(title)
        hasher.combine(updateDate)
        hasher.combine(choices)
    }
}

extension Decision: CustomStringConvertible {
    var description: String {
        """
        Decision: \(title)
        Choices: \(choices.map(\.description).joined(separator: "\n"))
        """
    }
}

@Model
class Choice {
    var uuid: UUID = UUID()
    var decision: Decision?
    var title: String
    var weight: Int
//    var sortValue: Double

    // 是否可以被选中
    var enable: Bool = true

    var createDate: Date
    // 选中状态
    var choosed: Bool = false

    init(content: String, weight: Int = 1) {
        title = content
        self.weight = weight
        createDate = .now
    }

    var weight4calc: Int {
        let hideWeight = Defaults[.equalWeight]
        return hideWeight ? 1 : weight
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
