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
    // MARK: Lifecycle

    init(uuid: UUID = UUID(), title: String, choices: [Choice], saved: Bool = false) {
        self.uuid = uuid
        self.title = title
        self.choices = choices
        self.saved = saved
        createDate = .now
        updateDate = .now
    }

    // MARK: Internal

    var uuid: UUID = UUID()
    var title: String = "Untitled"

    @Relationship(inverse: \Choice.decision)
    var choices: [Choice]? = [Choice]()
    // 已经保存
    var saved: Bool = false

    var displayModel: Int = DecisionDisplayMode.wheel.rawValue

    var createDate: Date = Date()
    var updateDate: Date = Date()

    var wheelVersion: Int = 0

    var unwrappedChoices: [Choice] {
        choices ?? []
    }

    var sortedChoices: [Choice] {
        guard let choices else { return [] }

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
        guard let choices else { return 0 }

        return choices.reduce(0) { partialResult, choice in
            partialResult + choice.weight
        }
    }

    func incWheelVersion() {
        wheelVersion = (wheelVersion + 1) % 65536
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
        guard let choices else { return "Decision: \(title)" }

        return """
        Decision: \(title)
        //        Choices: \(choices.map(\.description).joined(separator: "\n"))
        """
    }
}

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
