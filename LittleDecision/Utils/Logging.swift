//
//  Logging.swift
//  LittleDecision
//
//  Created by ailu on 2024/6/8.
//

import Foundation

import OSLog

class Logging {
    static let shared = Logger(subsystem: "shared", category: "decision")
    static let iapService = Logger(subsystem: "iapService", category: "decision")
}
