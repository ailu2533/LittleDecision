//
//  ChangeAction.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/10/31.
//

import Foundation

enum ChangeAction {
    // 切换了Decision
    case decisionUUID(UUID)
    case userDefaultsEqualWeight(Bool)
    case userDefaultsNoRepeat(Bool)
    // 编辑Decision的相关字段
    case decisionEdited(UUID)
}
