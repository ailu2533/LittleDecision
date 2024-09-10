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
        let decisions = currentDecision

        NavigationStack {
            Group {
                if let decisions {
                    DecisionView(currentDecision: decisions)
                } else {
                    ContentUnavailableView("没有数据", image: "plus")
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
        }
    }
}
