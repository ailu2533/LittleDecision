//
//  DecisionManagementView.swift
//  LittleDecision
//
//  Created by ailu on 2024/4/8.
//

import SwiftData
import SwiftUI

enum DecisionManagementSheetEnum: Identifiable {
    var id: UUID {
        UUID()
    }

    case add
    case edit(Decision)
}
