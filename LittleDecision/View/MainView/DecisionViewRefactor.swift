//
//  DecisionViewRefactor.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/10/29.
//

import LemonViews
import SwiftUI

// MARK: - DecisionViewRefactor

struct DecisionViewRefactor: View {
    // MARK: Internal

    var body: some View {
        VStack {
            MainViewDecisionAndChoiceTitleView(globalViewModel: globalViewModel)

            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            Button {
                globalViewModel.restore()
            } label: {
                Label("还原", systemImage: "arrow.clockwise")
            }
            .buttonStyle(FloatingButtonStyle())
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
    }

    // MARK: Private

    @Environment(GlobalViewModel.self) private var globalViewModel

    @ViewBuilder
    private var content: some View {
        GeometryReader { proxy in
            let size = proxy.size
            switch globalViewModel.decisionDisplayMode {
            case .wheel:
                PieChartView(globalViewModel: globalViewModel, size: size)
            case .stackedCards:
                DeckView(globalViewModel: globalViewModel, size: size)
            }
        }
    }
}
