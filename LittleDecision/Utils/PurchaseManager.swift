//
//  PurchaseManager.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/30.
//

import Foundation
import RevenueCat

class PurchaseManager: ObservableObject {
    static let shared = PurchaseManager()

    @Published var isPremium = false

    private init() {
        updatePurchaserInfo()
    }

    func updatePurchaserInfo() {
        Purchases.shared.getCustomerInfo { [weak self] purchaserInfo, error in
            if let error = error {
                print("Error fetching purchaser info: \(error.localizedDescription)")
                return
            }

            DispatchQueue.main.async {
                self?.isPremium = purchaserInfo?.entitlements.all["premium"]?.isActive == true
            }
        }
    }

//
//    func purchase(product: Purchases.Package) {
//        Purchases.shared.purchase(package: product) { [weak self] _, purchaserInfo, error, userCancelled in
//            if let error = error {
//                print("Error purchasing product: \(error.localizedDescription)")
//                return
//            }
//
//            if userCancelled {
//                print("User cancelled purchase")
//                return
//            }
//
//            DispatchQueue.main.async {
//                self?.isPremium = purchaserInfo?.entitlements.all["premium"]?.isActive == true
//            }
//        }
//    }

    func restorePurchases() {
        Purchases.shared.restorePurchases { [weak self] purchaserInfo, error in
            if let error = error {
                print("Error restoring purchases: \(error.localizedDescription)")
                return
            }

            DispatchQueue.main.async {
                self?.isPremium = purchaserInfo?.entitlements.all["premium"]?.isActive == true
            }
        }
    }
}
