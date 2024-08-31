//
//  MainView.swift
//  LittleDecision
//
//  Created by ailu on 2024/4/10.
//

import SceneKit
import SwiftData
import SwiftUI

//enum Tab: Int, CaseIterable, Identifiable {
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
//}

enum ActiveSheet: Identifiable {
    case decisionList, settings, skinList

    var id: Self { self }
}

struct MainView: View {
    @State private var activeSheet: ActiveSheet?

    var body: some View {
        NavigationStack {
            FirstView()
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
