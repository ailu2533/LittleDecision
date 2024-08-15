//
//  MainView.swift
//  LittleDecision
//
//  Created by ailu on 2024/4/10.
//

import SceneKit
import SwiftData
import SwiftUI

enum Tab: Int, CaseIterable, Identifiable {
    case wheel
    case decisions
    case settings

    var id: Int {
        rawValue
    }

    var title: LocalizedStringKey {
        switch self {
        case .wheel: return "转盘"
        case .decisions: return "决定"
        case .settings: return "设置"
        }
    }

    var icon: String {
        switch self {
        case .wheel: return "chart.pie"
        case .decisions: return "list.bullet"
        case .settings: return "gear"
        }
    }

    @ViewBuilder
    var view: some View {
        switch self {
        case .wheel: FirstView()
        case .decisions: DecisionListView()
        case .settings: SettingsView()
        }
    }
}

struct MainView: View {
    @State private var showListSheet = false
    @State private var showSettingsSheet = false

    var body: some View {
//        TabView {
//            ForEach(Tab.allCases) { tab in
//                tab.view
//                    .tabItem {
//                        Label(tab.title, systemImage: tab.icon)
//                    }
//                    .tag(tab)
//            }
//        }

        NavigationStack {
            FirstView()
                .toolbar {
                    ToolbarItemGroup(placement: .topBarLeading) {
                        Button(action: {
                            showSettingsSheet = true
                        }, label: {
                            Image(systemName: "gear")
                        })
                    }

                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button(action: {
                            showListSheet = true
                        }, label: {
                            Image(systemName: "list.bullet")
                        })
                    }
                }
                .sheet(isPresented: $showListSheet, content: {
                    DecisionListView()
                })
                .sheet(isPresented: $showSettingsSheet, content: {
                    SettingsView()
                })
        }
    }
}
