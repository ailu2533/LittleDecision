//
//  SubscriptionState.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/30.
//

import Foundation

enum SubscriptionState {
    case notSubscribed
    case inTrial(endDate: Date)
    case subscribed(endDate: Date)
}

extension SubscriptionState: CustomStringConvertible {
    var description: String {
        switch self {
        case .notSubscribed: "未訂閱"
        case let .inTrial(endDate): "試用期至 \(endDate.formatted(date: .abbreviated, time: .shortened))"
        case let .subscribed(endDate): "訂閱至 \(endDate.formatted(date: .abbreviated, time: .shortened))"
        }
    }
}
