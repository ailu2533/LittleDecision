//
//  LittleDecisionApp.swift
//  LittleDecision
//
//  Created by ailu on 2024/4/3.
//

import AVFoundation
import Defaults
import RevenueCat
import SwiftData
import SwiftUI
import TipKit

// MARK: - LittleDecisionApp

@main
struct LittleDecisionApp: App {
    // MARK: Lifecycle

    init() {
        let modelContainer = getModelContainer(isStoredInMemoryOnly: false)
        sharedModelContainer = modelContainer
        _globalViewModel = State(wrappedValue: GlobalViewModel(modelContext: modelContainer.mainContext))

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
                    globalViewModel.send(.decisionUUID(Defaults[.decisionID]))
                }
                .task {
                    await updateIapViewModel()
                }
                .sensoryFeedback(trigger: globalViewModel.status) { oldValue, newValue in
                    if oldValue == .none, newValue != .none {
                        return .impact(flexibility: .soft)
                    }

                    return .none
                }
        }
        .modelContainer(sharedModelContainer)
        .environment(globalViewModel)
    }

    // MARK: Private

    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    private let iapService: IAPService
    private var sharedModelContainer: ModelContainer

    @State private var premiumSubscriptionViewModel = SubscriptionViewModel(
        canAccessContent: false,
        isEligibleForTrial: true,
        subscriptionState: .notSubscribed
    )

    @State private var globalViewModel: GlobalViewModel
}

extension LittleDecisionApp {
    // MARK: Fileprivate

    private func updateIapViewModel() async {
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

    func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            Logging.shared.error("Failed to set audio session category. \(error)")
        }
    }
}
