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

// enum Tab: Int, CaseIterable, Identifiable {
//    case wheel
//    case decisions
//    case settings
//
//    var id: Int {
//        rawValue
//    }
//
//    var title: LocalizedStringKey {
//        switch self {
//        case .wheel: return "转盘"
//        case .decisions: return "决定"
//        case .settings: return "设置"
//        }
//    }
//
//    var icon: String {
//        switch self {
//        case .wheel: return "chart.pie"
//        case .decisions: return "list.bullet"
//        case .settings: return "gear"
//        }
//    }
//
//    @ViewBuilder
//    var view: some View {
//        switch self {
//        case .wheel: FirstView()
//        case .decisions: DecisionListView()
//        case .settings: SettingsView()
//        }
//    }
// }

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
                if currentDecision?.displayModel == DecisionDisplayMode.wheel.rawValue {
                    FirstView()
                } else {
                    DeckModeView()
                        .id(currentDecision.hashValue)
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
