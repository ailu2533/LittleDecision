//
//  LittleDecisionApp.swift
//  LittleDecision
//
//  Created by ailu on 2024/4/3.
//

import AVFoundation
import RevenueCat
import SwiftData
import SwiftUI
import TipKit

// appl_MHQLRbFiJoJSOTPSEtTvRzTnYnV

func setupAudioSession() {
    do {
        try AVAudioSession.sharedInstance().setCategory(.ambient)
        try AVAudioSession.sharedInstance().setActive(true)
    } catch {
        Logging.shared.error("Failed to set audio session category. \(error)")
    }
}

@main
struct LittleDecisionApp: App {
    init() {
        vm = DecisionViewModel(modelContext: sharedModelContainer.mainContext)
        try? Tips.configure()
        configureRevenueCat()
        setupAudioSession()
    }

    var sharedModelContainer: ModelContainer = getModelContainer(isStoredInMemoryOnly: false)

    var vm: DecisionViewModel

    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear {
                    insertData(ctx: sharedModelContainer.mainContext)
                }
        }
        .modelContainer(sharedModelContainer)
        .environment(vm)
    }

    private func configureRevenueCat() {
        Purchases.logLevel = .debug // 开发时使用,发布时请移除
        Purchases.configure(withAPIKey: "appl_DJrbtXcoBtXHBPYNySzEnrrGFdV")
    }
}
