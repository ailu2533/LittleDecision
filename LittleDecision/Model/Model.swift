//
//  Model.swift
//  LittleDecision
//
//  Created by ailu on 2024/4/3.
//

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

    var createDate: Date
    var updateDate: Date

    init(uuid: UUID = UUID(), title: String, choices: [Choice]) {
        self.uuid = uuid
        self.title = title
        self.choices = choices
        createDate = .now
        updateDate = .now
    }

    var sortedChoices: [Choice] {
        return choices.sorted(by: {
            $0.sortValue < $1.sortValue
        })
    }

    // 还原转盘
    func reset() {
        choices.forEach {
            $0.choosed = false
        }
    }

    // 总权重
    var totalWeight: Double {
        var res = 0.0
        choices.forEach {
            res += Double($0.weight)
        }
        return res
    }
}

extension Decision: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
        hasher.combine(title)
    }
}

extension Decision: CustomStringConvertible {
    var description: String {
        return """
        Decision: \(title)
        Choices: \(choices.map { $0.description }.joined(separator: "\n"))
        """
    }
}

@Model
class Choice {
    var uuid: UUID = UUID()
    var decision: Decision?
    var title: String
    var weight: Int
    var sortValue: Double

    var createDate: Date
    // 选中状态
    var choosed: Bool = false

    init(content: String, weight: Int, sortValue: Double) {
        title = content
        self.weight = weight
        createDate = .now
        self.sortValue = sortValue
    }
}

extension Choice: CustomStringConvertible {
    var description: String {
        return """
        Choice: \(title)
        Weight: \(weight)
        Sort Value: \(sortValue)
        """
    }
}
