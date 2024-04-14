//
//  LittleDecisionApp.swift
//  LittleDecision
//
//  Created by ailu on 2024/4/3.
//

import SwiftData
import SwiftUI

@main
struct LittleDecisionApp: App {
    init() {
        vm = DecisionViewModel(modelContext: sharedModelContainer.mainContext)
    }

    var sharedModelContainer: ModelContainer = getModelContainer(isStoredInMemoryOnly: false)

    var vm: DecisionViewModel

    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(sharedModelContainer)
        .environment(vm)
    }
}
