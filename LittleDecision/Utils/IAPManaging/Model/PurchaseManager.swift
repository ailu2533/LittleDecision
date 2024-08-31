//
//  PurchaseManager.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/30.
//

import Foundation
import RevenueCat

let lifetimePro = "lifetime pro"

protocol IAPService {
    static func configOnLaunch()
    func monitoringSubscriptionInfoUpdates(updateHandler: @escaping (SubscriptionInfo) -> Void) async throws
}

final class RevenueCatService {
    private let service: Purchases
    private let didHandleInitialState: Bool
    private let entitlement: String

    init(service: Purchases = .shared,
         didHandleInitialState: Bool = false,
         entitlement: String = RCConstants.premium) {
        self.service = service
        self.didHandleInitialState = didHandleInitialState
        self.entitlement = entitlement
    }
}

extension RevenueCatService: IAPService {
    static func configOnLaunch() {
        Purchases.logLevel = .debug
        Purchases.configure(with:
            .init(withAPIKey: RCConstants.apiKey)
                .with(entitlementVerificationMode: .informational)
        )
    }

    func monitoringSubscriptionInfoUpdates(updateHandler: @escaping (SubscriptionInfo) -> Void) async throws {
        for try await customerInfo in service.customerInfoStream {
            guard customerInfo.entitlements.verification.isVerified else {
                throw IAPError.verificationFailed
            }
            let subscriptionInfo = if !didHandleInitialState {
                try await getInitialSubscriptionInfo(from: customerInfo)
            } else {
                try getUpdatedSubscriptionInfo(from: customerInfo)
            }
            updateHandler(subscriptionInfo)
        }
    }
}

// MARK: - helper

extension RevenueCatService {
    func getInitialSubscriptionInfo(from customerInfo: CustomerInfo) async throws -> SubscriptionInfo {
        guard let state = convertCustomerInfo(customerInfo) else {
            return .init(canAccessContent: false, isEligibleForTrial: try await checkTrialEligibility(), subscriptionState: .notSubscribed)
        }
        return state
    }

    func getUpdatedSubscriptionInfo(from customerInfo: CustomerInfo) throws -> SubscriptionInfo {
        guard let state = convertCustomerInfo(customerInfo) else {
            throw IAPError.missingEntitlement
        }
        return state
    }

    func convertCustomerInfo(_ customerInfo: CustomerInfo) -> SubscriptionInfo? {
        Logging.shared.debug("\(customerInfo)")
//        guard
//            let entitlement = customerInfo.entitlements[entitlement],
//            entitlement.isActive,
//            let expirationDate = entitlement.expirationDate else {
//            return nil
//        }
//        let state: SubscriptionState = switch entitlement.periodType {
//        case .normal: .subscribed(endDate: expirationDate)
//        case .intro, .trial: .inTrial(endDate: expirationDate)
//        }

        guard let entitlement = customerInfo.entitlements[entitlement],
              entitlement.isActive else {
            return nil
        }

        return .init(canAccessContent: true, isEligibleForTrial: false, subscriptionState: .subscribed(endDate: .distantFuture))
    }

    func checkTrialEligibility() async throws -> Bool {
        let offerings = try await service.offerings()
        guard let product = offerings.current?.availablePackages.first?.storeProduct else {
            throw IAPError.noAvailableStoreProduct
        }
        return (await service.checkTrialOrIntroDiscountEligibility(product: product)).isEligible
    }
}
