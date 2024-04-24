//
//  DecisionViewModel.swift
//  LittleDecision
//
//  Created by ailu on 2024/4/8.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
class DecisionViewModel {
    var modelContext: ModelContext
    var navigationPath: NavigationPath = NavigationPath()

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
}
