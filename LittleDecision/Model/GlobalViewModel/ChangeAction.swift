//
//  ChangeAction.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/10/31.
//

import Foundation

enum ChangeAction: CustomStringConvertible {
    // 切换了Decision
    case decisionUUID(UUID?)
    case userDefaultsEqualWeight(Bool)
    case userDefaultsNoRepeat(Bool)
    // 编辑Decision的相关字段
    case decisionEdited(UUID)

    // MARK: Internal

    var description: String {
        switch self {
        case let .decisionUUID(uuid):
            return "Changed Decision: \(uuid?.uuidString ?? "nil")"

        case let .userDefaultsEqualWeight(isEqual):
            return "Changed Equal Weight Setting: \(isEqual)"

        case let .userDefaultsNoRepeat(noRepeat):
            return "Changed No Repeat Setting: \(noRepeat)"

        case let .decisionEdited(uuid):
            return "Edited Decision: \(uuid.uuidString)"
        }
    }
}
