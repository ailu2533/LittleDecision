//
//  Utils.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/15.
//

import Foundation

let percentFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .percent
    formatter.minimumFractionDigits = 1
    formatter.maximumFractionDigits = 1
    return formatter
}()

func probability(_ weight: Int, _ total: Int) -> Double {
    guard total > 0 else { return 0 }
    let percentage = min(1, Double(weight) / Double(total))
    return percentage
}
