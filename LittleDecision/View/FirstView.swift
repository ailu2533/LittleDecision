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
                Spacer()
                VStack {
                    Text(currentDecision?.title ?? "")
                        .font(.title)
                    Text(selectedChoice?.title ?? "??")
                        .font(.title2)
                }

                Spacer()
                if let currentDecision {
                    PieChartView(selection: $selectedChoice, currentDecision: currentDecision)
                        .frame(maxHeight: 400)
//                        .background(.blue.opacity(0.3))
                }
                
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
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

struct CarouselSettingsView: View {
    @AppStorage("noRepeat") private var noRepeat = false
    @AppStorage("equalWeight") private var equalWeight = false
    @AppStorage("rotationTime") private var rotationTime = 4

    var body: some View {
        NavigationStack {
            Form {
                Toggle(isOn: $noRepeat, label: {
                    Text("不重复抽取")
                })

                Toggle(isOn: $equalWeight, label: {
                    Text("隐藏权重")
                })

                Picker(selection: $rotationTime) {
                    ForEach([2, 3, 4, 5, 6, 7, 8], id: \.self) {
                        Text("\($0)秒")
                            .tag($0)
                    }
                } label: {
                    Text("旋转时长")
                }
            }
        }
    }
}
