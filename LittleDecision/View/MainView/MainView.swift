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
    @Environment(\.modelContext) private var modelContext

    private var currentDecision: Decision? {
        let predicate = #Predicate<Decision> { $0.uuid == decisionId }
        let descriptor = FetchDescriptor(predicate: predicate)

        do {
            let res = try modelContext.fetch(descriptor).first
            Logging.shared.debug("currentDecision: \(res.debugDescription)  isNil \(res == nil)")
            return res
        } catch {
            Logging.shared.error("currentDecision: \(error)")
            return nil
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if let currentDecision {
                    DecisionView(currentDecision: currentDecision)
                } else {
                    ContentUnavailableView("没有数据", image: "plus")
                }
            }
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
