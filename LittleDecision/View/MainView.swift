//
//  MainView.swift
//  LittleDecision
//
//  Created by ailu on 2024/4/10.
//

import SceneKit
import SwiftData
import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            FirstView()
                .tabItem {
                    Label("转盘", systemImage: "chart.pie")
                }
            DecisionListView()
                .tabItem {
                    Label("决定", systemImage: "list.bullet")
                }

            SettingsView()
                .tabItem {
                    Label("设置", systemImage: "gear")
                }
        }
    }
}

#Preview {
    MainView()
}
