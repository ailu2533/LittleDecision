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
    var uuid: UUID = UUID()
    var title: String

    @Relationship(inverse: \Choice.decision)
    var choices: [Choice]

    var createDate: Date
    var updateDate: Date

    init(title: String, choices: [Choice]) {
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
    var sortValue: Int

    var createDate: Date
    // 选中状态
    var choosed: Bool = false

    init(content: String, weight: Int, sortValue: Int) {
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

@Observable
class ViewModel {
    private let ctx: ModelContext

    init(ctx: ModelContext) {
        self.ctx = ctx
    }

    // 查询所有 decision

    func fetchAllDecisions() -> [Decision] {
        let descriptor = FetchDescriptor<Decision>(sortBy: [SortDescriptor<Decision>(\Decision.createDate, order: .reverse)])

        do {
            let res = try ctx.fetch(descriptor)
            return res
        } catch {
            print(error.localizedDescription)
        }

        return []
    }

    // 查询一个 decision 下的所有 choice
}
