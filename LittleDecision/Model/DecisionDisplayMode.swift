//
//  DecisionDisplayMode.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/7.
//

import Defaults
import SwiftUI

enum DecisionDisplayMode: Int, Identifiable, Codable, CaseIterable, Defaults.Serializable {
    case wheel = 1 // 转盘模式
    case stackedCards = 2 // 堆叠卡片模式

    var id: Int {
        rawValue
    }

    var text: LocalizedStringKey {
        switch self {
        case .wheel:
            return "转盘模式"
        case .stackedCards:
            return "卡片模式"
        }
    }
}
