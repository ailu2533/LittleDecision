//
//  MainView.swift
//  LittleDecision
//
//  Created by ailu on 2024/4/10.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            PieChartView()
                .tabItem {
                    Label("转盘", systemImage: "chart.pie")
                }

            Text("随机数")
                .tabItem {
                    Label("随机数", systemImage: "42.circle.fill")
                }
            Text("我的")
                .tabItem {
                    Label("我的", systemImage: "house.circle.fill")
                }
        }
    }
}

#Preview {
    MainView()
}
