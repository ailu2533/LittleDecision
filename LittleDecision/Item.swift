//
//  Item.swift
//  LittleDecision
//
//  Created by ailu on 2024/4/3.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
