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
    @AppStorage("decisionId") var decisionId: String = UUID().uuidString

    @State private var didVersion = 0

    @Environment(\.modelContext) private var modelContext

    @Environment(DecisionViewModel.self) private var vm

    private var currentDecision: Decision {
        let did = UUID(uuidString: decisionId)!

        let predicate = #Predicate<Decision> {
            $0.uuid == did
        }

        let descriptor = FetchDescriptor(predicate: predicate)

        do {
            let decisions = try modelContext.fetch(descriptor)

            if let decision = decisions.first {
                return decision
            }

        } catch {
            print(error.localizedDescription)
        }

        return .init(title: "请选择决定", choices: [])
    }

    var body: some View {
        TabView {
            FirstView()
                .tabItem {
                    Label("转盘", systemImage: "chart.pie")
                }
            NavigationStack {
                DecisionListView()
            }
            .tabItem {
                Label("决定", systemImage: "list.bullet")
            }

            CarouselSettingsView()
                .tabItem {
                    Label("设置", systemImage: "gear")
                }
        }
    }
}

#Preview {
    MainView()
}
