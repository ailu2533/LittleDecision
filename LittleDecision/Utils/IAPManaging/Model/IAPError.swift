//
//  IAPError.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/30.
//

import Foundation

enum IAPError: Error {
    case verificationFailed
    case noAvailableStoreProduct
    case missingEntitlement
}
