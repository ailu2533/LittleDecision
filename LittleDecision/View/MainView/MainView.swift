//
//  MainView.swift
//  LittleDecision
//
//  Created by ailu on 2024/4/10.
//

import Defaults
import SceneKit
import SwiftData
import SwiftUI

enum ActiveSheet: Identifiable {
    case decisionList, settings, skinList

    var id: Self { self }
}

struct MainView: View {
    @State private var activeSheet: ActiveSheet?

    @Default(.decisionId) private var decisionId

    @Environment(\.modelContext)
    private var modelContext
    
    
    /// An identifier for the three-step process the person completes before this app chooses to request a review.
    @AppStorage("processCompletedCount") var processCompletedCount = 0

    /// The most recent app version that prompts for a review.
    @AppStorage("lastVersionPromptedForReview") var lastVersionPromptedForReview = ""

    @Environment(\.requestReview) private var requestReview
    

    private var currentDecision: Decision? {
        let predicate = #Predicate<Decision> { $0.uuid == decisionId }
        let descriptor = FetchDescriptor(predicate: predicate)

        do {
            let res = try modelContext.fetch(descriptor).first
            return res
        } catch {
            Logging.shared.error("currentDecision: \(error)")
            return nil
        }
    }

    var body: some View {
        let _ = Self._printChanges()
        let decision = currentDecision

        NavigationStack {
            Group {
                if let decision {
                    DecisionView(currentDecision: decision)
                } else {
                    ContentUnavailableView("没有数据", systemImage: "envelope.open")
                }
            }
            .ignoresSafeArea(.keyboard)
            .mainBackground()
            .toolbar {
                ToolbarView(activeSheet: $activeSheet)
            }
            .sheet(item: $activeSheet) { item in
                switch item {
                case .decisionList:
                    DecisionListView()
                case .settings:
                    SettingsView()
                case .skinList:
                    SkinListView()
                }
            }
            
            .onAppear {
                processCompletedCount += 1
            }
            .onChange(of: processCompletedCount) { _, _ in
                guard let currentAppVersion = Bundle.currentAppVersion else {
                    return
                }
                
                Logging.shared.debug("processCompletedCount \(processCompletedCount)")

                if processCompletedCount >= 5, currentAppVersion != lastVersionPromptedForReview {
                    presentReview()

                    // The app already displayed the rating and review request view. Store this current version.
                    lastVersionPromptedForReview = currentAppVersion
                }
            }
            
        }
    }
    
    
    /// Presents the rating and review request view after a two-second delay.
    private func presentReview() {
        Task {
            // Delay for two seconds to avoid interrupting the person using the app.
            try await Task.sleep(for: .seconds(2))
            await requestReview()
        }
    }
    
}
