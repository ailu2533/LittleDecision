//
//  SpinCellRawItem.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/16.
//

import Foundation

struct SpinCellItem: Identifiable {
    let id: UUID
    let title: String
    let weight: CGFloat
    let enabled: Bool

    init(id: UUID, title: String, weight: CGFloat = 1, enabled: Bool = true) {
        self.id = id
        self.title = title
        self.weight = weight
        self.enabled = enabled
    }
}


// 首先确保 SpinCellRawItem 遵循 Hashable 协议
extension SpinCellItem: Hashable {
    public func hash(into hasher: inout Hasher) {
        // 根据 SpinCellRawItem 的属性来实现哈希函数
        // 这里假设 SpinCellRawItem 有 id 和 weight 属性
        hasher.combine(id)
        hasher.combine(weight)
        hasher.combine(enabled)
        hasher.combine(title)
    }

    public static func == (lhs: SpinCellItem, rhs: SpinCellItem) -> Bool {
        // 实现相等性比较
        // 这里假设两个 SpinCellRawItem 的 id 相同就认为它们相等
        return lhs.id == rhs.id &&
            lhs.weight == rhs.weight &&
            lhs.enabled == rhs.enabled &&
            lhs.title == rhs.title
    }
}
