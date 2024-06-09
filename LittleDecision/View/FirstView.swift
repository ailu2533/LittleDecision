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
            let res = try modelContext.fetch(descriptor).first
            Logging.shared.debug("currentDecision: \(res.debugDescription)  isNil \(res==nil)")
            return res
        } catch {
            Logging.shared.error("currentDecision: \(error)")
        }

        return nil
    }

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                VStack {
                    Text(currentDecision?.title ?? "xx")
                        .font(.title)
                        .fontWeight(.bold)
                    Text(selectedChoice?.title ?? "??")
                        .font(.title2)
                }

                Spacer()
                if let currentDecision {
                    PieChartNoRepeatView(selection: $selectedChoice, currentDecision: currentDecision)
                        .padding(.horizontal, 12)
                } else {
                    ContentUnavailableView(label: {
                        Label("No Mail", systemImage: "tray.fill")
                    })
                }

                Spacer()
            }
        }
    }
}

#Preview {
    FirstView()
}
