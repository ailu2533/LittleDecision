//
//  Decision.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/10/31.
//

import Foundation
import SwiftData

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

//    var wheelVersion: Int = 0

    var unwrappedChoices: [Choice] {
        choices ?? []
    }

    var sortedChoices: [Choice] {
        guard let choices else { return [] }

        return choices.sorted(by: {
            if $0.createDate == $1.createDate {
                return $0.uuid < $1.uuid
            }
            return $0.createDate < $1.createDate
        })
    }

    // 总权重
    var totalWeight: Int {
        get async {
            guard let choices else { return 0 }

            return choices.reduce(0) { partialResult, choice in
                partialResult + choice.weight
            }
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
        guard let choices else { return "Decision: \(title)" }

        return """
        Decision: \(title)
        //        Choices: \(choices.map(\.description).joined(separator: "\n"))
        """
    }
}
