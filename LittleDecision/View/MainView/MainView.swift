//
//  MainView.swift
//  LittleDecision
//
//  Created by ailu on 2024/4/10.
//

import Defaults
// import SceneKit
import SwiftData
import SwiftUI

struct MainView: View {
    // MARK: Internal

    var body: some View {
        let _ = Self._printChanges()

        NavigationStack {
            mainContent
                .ignoresSafeArea(.keyboard)
                .mainBackground()
                .toolbar {
                    ToolbarView(activeSheet: $activeSheet)
                }
                .sheet(item: $activeSheet) { item in
                    item
                }

                .onAppear {
                    processCompletedCount += 1
                }
                .onChange(of: processCompletedCount) { _, _ in
                    requestReviewHandler()
                }
        }
        .task(id: decisionID) {
            currentDecision = fetchDecision()
            selectedChoice = nil
        }
    }

    // MARK: Private

    @State private var activeSheet: ActiveSheet?

    @Default(.decisionID) private var decisionID
    @Default(.processCompletedCount) private var processCompletedCount
    @Default(.lastVersionPromptedForReview) private var lastVersionPromptedForReview

    @Environment(\.modelContext)
    private var modelContext

    @Environment(\.requestReview) private var requestReview

    @State private var currentDecision: Decision?
    @State private var selectedChoice: Choice?

    @ViewBuilder
    private var mainContent: some View {
        if let currentDecision {
            DecisionView(selectedChoice: $selectedChoice, currentDecision: currentDecision)
        } else {
            ContentUnavailableView("没有数据", systemImage: "envelope.open")
        }
    }
}

extension MainView {
    private func fetchDecision() -> Decision? {
        let predicate = #Predicate<Decision> { $0.uuid == decisionID }
        let descriptor = FetchDescriptor(predicate: predicate)

        do {
            let res = try modelContext.fetch(descriptor).first
            return res
        } catch {
            Logging.shared.error("currentDecision: \(error)")
            return nil
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

    private func requestReviewHandler() {
        guard let currentAppVersion = Bundle.currentAppVersion else {
            return
        }

        Logging.shared.debug("processCompletedCount \(processCompletedCount)")

        if processCompletedCount >= 5, currentAppVersion != lastVersionPromptedForReview {
            presentReview()

            // The app already displayed the rating and review request view. Store this current version.
            lastVersionPromptedForReview = currentAppVersion
            processCompletedCount = 0
        }
    }
}
