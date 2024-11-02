//
//  LotteryLogic.swift
//  LittleDecision
//
//  Created by ailu on 2024/6/10.
//

import Foundation

enum LotteryViewModel {
    // MARK: selectChoice

    static func selectChoice(from choices: [ChoiceItem]) -> (choice: ChoiceItem?, randomAngle: Double)? {
        let totalWeight = choices.reduce(0) { $0 + $1.weight }
        if totalWeight == 0 { return nil } // 防止除以零的错误

        // 随机选择一个choice
        let randomWeight = Int.random(in: 0 ..< totalWeight)
        var cumulativeWeight = 0
        var selectedChoice: ChoiceItem?

        for choice in choices {
            cumulativeWeight += choice.weight
            if randomWeight < cumulativeWeight {
                selectedChoice = choice
                break
            }
        }

        guard let choice = selectedChoice else { return nil }

        // 计算角度范围
        var startAngle = 0.0
        var endAngle = 0.0
        cumulativeWeight = 0

        for choice in choices {
            let angle = (Double(choice.weight) / Double(totalWeight)) * 360
            if choice == selectedChoice {
                endAngle = startAngle + angle
                break
            }
            startAngle += angle
        }

        // 生成 startAngle 和 endAngle 之间的一个平均值
        let randomAngle = (startAngle + endAngle) / 2

        return (choice, randomAngle)
    }

    static func selectChoiceExcludeDisable(from choices: [ChoiceItem]) -> (choice: ChoiceItem?, randomAngle: Double)? {
        let filteredTotalWeight = choices.filter(\.enable).reduce(0) { $0 + $1.weight }
        if filteredTotalWeight == 0 { return nil } // 防止除以零的错误

        // 随机选择一个choice
        let randomWeight = Int.random(in: 0 ..< filteredTotalWeight)
        var cumulativeWeight = 0
        var selectedChoice: ChoiceItem?

        for choice in choices.filter(\.enable) {
            cumulativeWeight += choice.weight
            if randomWeight < cumulativeWeight {
                selectedChoice = choice
                break
            }
        }

        guard let choice = selectedChoice else { return nil }

        let totalWeight = choices.reduce(0) { $0 + $1.weight }

        // 计算角度范围
        var startAngle = 0.0
        var endAngle = 0.0
        cumulativeWeight = 0

        for choice in choices {
            let angle = (Double(choice.weight) / Double(totalWeight)) * 360
            if choice == selectedChoice {
                endAngle = startAngle + angle
                break
            }
            startAngle += angle
        }

        // 生成 startAngle 和 endAngle 之间的一个平均值
        let randomAngle = (startAngle + endAngle) / 2

        return (choice, randomAngle)
    }

    static func select(from choices: [ChoiceItem], noRepeat: Bool) -> (choice: ChoiceItem?, randomAngle: Double)? {
//        let noRepeat = Defaults[.noRepeat]

        if noRepeat {
            return selectChoiceExcludeDisable(from: choices)
        }
        return selectChoice(from: choices)
    }

    static func randomStringStream(from array: [ChoiceItem], numOfDraw: Int, repeatDraw: Bool) -> AsyncStream<ChoiceItem> {
        AsyncStream { continuation in

            Task {
                if repeatDraw {
                    for _ in 0 ..< numOfDraw {
                        guard let (choice, _) = selectChoice(from: array), let choice else {
                            return
                        }

                        continuation.yield(choice)
                    }

                } else {
                    var tmp = array

                    // 生成1万个随机数据
                    for _ in 0 ..< numOfDraw {
                        guard let (choice, _) = selectChoice(from: tmp), let choice else {
                            return
                        }

                        continuation.yield(choice)

                        tmp.removeAll { choice == $0 }
                    }
                }

                continuation.finish()
            }
        }
    }
}
