//
//  LotteryLogic.swift
//  LittleDecision
//
//  Created by ailu on 2024/6/10.
//

import Defaults
import Foundation

class LotteryViewModel {
    static func selectChoice(from choices: [Choice], basedOn rotateAngle: Double) -> Choice? {
        guard !choices.isEmpty else { return nil }

        let totalWeight = choices.reduce(0) { $0 + $1.weight }
        guard totalWeight > 0 else { return choices.randomElement() }

        // 计算每个 choice 的角度范围
        var angles = [Double]()
        var cumulativeAngle = 0.0

        for choice in choices {
            let angle = (Double(choice.weight) / Double(totalWeight)) * 360
            cumulativeAngle += angle
            angles.append(cumulativeAngle)
        }

        // 根据 rotateAngle 确定选中的 choice
        let adjustedAngle = rotateAngle.truncatingRemainder(dividingBy: 360)

        // 使用二分查找来确定 adjustedAngle 落在哪个区间
        var low = 0
        var high = angles.count - 1

        while low <= high {
            let mid = (low + high) / 2
            if adjustedAngle < angles[mid] {
                if mid == 0 || adjustedAngle >= angles[mid - 1] {
                    return choices[mid]
                }
                high = mid - 1
            } else {
                low = mid + 1
            }
        }

        return choices.last // 如果没有找到，返回最后一个选项
    }

    static func selectChoice(from choices: [Choice]) -> (choice: Choice?, randomAngle: Double)? {
        let totalWeight = choices.reduce(0) { $0 + $1.weight4calc }
        if totalWeight == 0 { return nil } // 防止除以零的错误

        // 随机选择一个choice
        let randomWeight = Int.random(in: 0 ..< totalWeight)
        var cumulativeWeight = 0
        var selectedChoice: Choice?

        for choice in choices {
            cumulativeWeight += choice.weight4calc
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
            let angle = (Double(choice.weight4calc) / Double(totalWeight)) * 360
            if choice === selectedChoice {
                endAngle = startAngle + angle
                break
            }
            startAngle += angle
        }

        // 生成 startAngle 和 endAngle 之间的一个平均值
        let randomAngle = (startAngle + endAngle) / 2

        return (choice, randomAngle)
    }

    static func selectChoiceExcludeDisable(from choices: [Choice]) -> (choice: Choice?, randomAngle: Double)? {
        let filteredTotalWeight = choices.filter(\.enable).reduce(0) { $0 + $1.weight4calc }
        if filteredTotalWeight == 0 { return nil } // 防止除以零的错误

        // 随机选择一个choice
        let randomWeight = Int.random(in: 0 ..< filteredTotalWeight)
        var cumulativeWeight = 0
        var selectedChoice: Choice?

        for choice in choices.filter(\.enable) {
            cumulativeWeight += choice.weight4calc
            if randomWeight < cumulativeWeight {
                selectedChoice = choice
                break
            }
        }

        guard let choice = selectedChoice else { return nil }

        let totalWeight = choices.reduce(0) { $0 + $1.weight4calc }

        // 计算角度范围
        var startAngle = 0.0
        var endAngle = 0.0
        cumulativeWeight = 0

        for choice in choices {
            let angle = (Double(choice.weight4calc) / Double(totalWeight)) * 360
            if choice === selectedChoice {
                endAngle = startAngle + angle
                break
            }
            startAngle += angle
        }

        // 生成 startAngle 和 endAngle 之间的一个平均值
        let randomAngle = (startAngle + endAngle) / 2

        return (choice, randomAngle)
    }

    static func select(from choices: [Choice]) -> (choice: Choice?, randomAngle: Double)? {
        let noRepeat = Defaults[.noRepeat]

        if noRepeat {
            return selectChoiceExcludeDisable(from: choices)
        }
        return selectChoice(from: choices)
    }
}
