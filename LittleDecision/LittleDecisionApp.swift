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
    // MARK: Lifecycle

    init() {
        self._vm = State(wrappedValue: DecisionViewModel(modelContext: sharedModelContainer.mainContext))
        try? Tips.configure()

        RevenueCatService.configOnLaunch()
        iapService = RevenueCatService()

        setupAudioSession()
    }

    // MARK: Internal

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(premiumSubscriptionViewModel)
                .onAppear {
                    insertData(ctx: sharedModelContainer.mainContext)
                }
                .task {
                    await  updateIapViewModel()
                }
        }
        .modelContainer(sharedModelContainer)
        .environment(vm)
    }

    // MARK: Fileprivate

    fileprivate func updateIapViewModel() async {
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

    // MARK: Private

    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    private let iapService: IAPService
    private var sharedModelContainer: ModelContainer = getModelContainer(isStoredInMemoryOnly: false)

    @State private var vm: DecisionViewModel

    @State private var premiumSubscriptionViewModel = SubscriptionViewModel(
        canAccessContent: false,
        isEligibleForTrial: true,
        subscriptionState: .notSubscribed
    )
}
