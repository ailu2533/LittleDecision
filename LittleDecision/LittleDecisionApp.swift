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
    let iapService: IAPService
//    @State var premiumSubscriptionInfo: SubscriptionInfo?

    @State var premiumSubscriptionViewModel = SubscriptionViewModel(canAccessContent: false, isEligibleForTrial: true, subscriptionState: .notSubscribed)

    init() {
        vm = DecisionViewModel(modelContext: sharedModelContainer.mainContext)
        try? Tips.configure()

        RevenueCatService.configOnLaunch()
        iapService = RevenueCatService()

        setupAudioSession()
    }

    var sharedModelContainer: ModelContainer = getModelContainer(isStoredInMemoryOnly: false)

    var vm: DecisionViewModel

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(premiumSubscriptionViewModel)
                .onAppear {
                    insertData(ctx: sharedModelContainer.mainContext)
                }
                .task {
                    do {
                        try await iapService.monitoringSubscriptionInfoUpdates { premiumSubscriptionInfo in
                            premiumSubscriptionViewModel.canAccessContent = premiumSubscriptionInfo.canAccessContent
                            premiumSubscriptionViewModel.isEligibleForTrial = premiumSubscriptionInfo.isEligibleForTrial
                            premiumSubscriptionViewModel.subscriptionState = premiumSubscriptionInfo.subscriptionState
                        }
                    } catch {
                        Logging.iapService.error("Error on handling customer info updates: \(error, privacy: .public)")
                    }
                }
        }
        .modelContainer(sharedModelContainer)
        .environment(vm)
    }
}
