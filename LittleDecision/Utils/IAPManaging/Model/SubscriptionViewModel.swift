//
//  SubscriptionViewModel.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/30.
//

import Foundation

@Observable
class SubscriptionViewModel {
    var canAccessContent: Bool
    var isEligibleForTrial: Bool
    var subscriptionState: SubscriptionState

    init(canAccessContent: Bool, isEligibleForTrial: Bool, subscriptionState: SubscriptionState) {
        self.canAccessContent = canAccessContent
        self.isEligibleForTrial = isEligibleForTrial
        self.subscriptionState = subscriptionState
    }
}
