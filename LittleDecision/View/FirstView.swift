//
//  FirstView.swift
//  LittleDecision
//
//  Created by ailu on 2024/6/8.
//

import SwiftData
import SwiftUI

struct FirstView: View {
    @AppStorage("decisionId") var decisionId: String = UUID().uuidString

    @Environment(\.modelContext)
    private var modelContext

    @Environment(DecisionViewModel.self)
    private var vm

    @State private var selectedChoice: Choice?

    private var currentDecision: Decision? {
        guard let did = UUID(uuidString: decisionId) else { return nil }

        let p = #Predicate<Decision> {
            $0.uuid == did
        }

        let descriptor = FetchDescriptor(predicate: p)

        do {
            return try modelContext.fetch(descriptor).first
        } catch {
            Logging.shared.error("currentDecision: \(error)")
        }

        return nil
    }

    var body: some View {
        NavigationStack {
            VStack {
                Text(decisionId)

                if let currentDecision {
                    PieChartView(currentDecision: currentDecision, selection: $selectedChoice)
                }
            }
            .toolbar {
                ToolbarItem {
                    NavigationLink {
                        DecisionListView()
                    } label: {
                        Label("决定列表", systemImage: "list.bullet")
                    }
                }
            }
        }
    }
}

#Preview {
    FirstView()
}
