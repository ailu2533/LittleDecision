//
//  LittleDecisionApp.swift
//  LittleDecision
//
//  Created by ailu on 2024/4/3.
//

import SwiftData
import SwiftUI
import SwiftUI_Keyboard_Observer
import TipKit

@main
struct LittleDecisionApp: App {
    init() {
        vm = DecisionViewModel(modelContext: sharedModelContainer.mainContext)
        try? Tips.configure()

    }

    var sharedModelContainer: ModelContainer = getModelContainer(isStoredInMemoryOnly: false)

    var vm: DecisionViewModel

    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear {
                    insertData(ctx: sharedModelContainer.mainContext)
                }
                .observeSoftwareKeyboard()

        }
        .modelContainer(sharedModelContainer)
        .environment(vm)

    }
}
