//
//  DecisionViewRefactor.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/10/29.
//

import Defaults
import SwiftData
import SwiftUI

struct DecisionViewRefactor: View {
    // MARK: Internal

    var body: some View {
        VStack {
            MainViewDecisionAndChoiceTitleView(globalViewModel: globalViewModel)

            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding()

    }

    // MARK: Private

    @Environment(GlobalViewModel.self) private var globalViewModel

    @Environment(\.modelContext) private var modelContext

    @ViewBuilder
    private var content: some View {
        switch globalViewModel.decisionDisplayMode {
        case .wheel:
            PieChartView(globalViewModel: globalViewModel)
        case .stackedCards:
            DeckHelperViewRefactor(globalViewModel: globalViewModel)
        }
    }
}

extension DecisionViewRefactor {
    private func fetchDecision(decisionID: UUID) -> Decision? {
        let predicate = #Predicate<Decision> { $0.uuid == decisionID }
        let descriptor = FetchDescriptor(predicate: predicate)

        return try? modelContext.fetch(descriptor).first
    }
}
