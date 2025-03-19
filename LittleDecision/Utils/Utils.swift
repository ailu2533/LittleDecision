//
//  Utils.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/15.
//

import Foundation

func probability(_ weight: Int, _ total: Int) -> Double {
    guard total > 0 else { return 0 }
    let percentage = min(1, Double(weight) / Double(total))
    return percentage
}
