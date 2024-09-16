//
//  SpinCellRawItem.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/16.
//

import Foundation

struct SpinCellRawItem: Identifiable {
//    let id = UUID()
    let title: String
    let weight: CGFloat
    let enabled: Bool

    var id: String {
        return "\(title) \(weight) \(enabled)"
    }

    init(title: String, weight: CGFloat = 1, enabled: Bool = true) {
        self.title = title
        self.weight = weight
        self.enabled = enabled
    }
}
