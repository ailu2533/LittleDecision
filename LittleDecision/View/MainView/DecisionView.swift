//
//  DecisionViewRefactor.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/10/29.
//

import LemonViews
import SwiftUI

// MARK: - DecisionView

struct DecisionView: View {
    // MARK: Internal

    var body: some View {
        VStack {
            MainViewDecisionAndChoiceTitleView(globalViewModel: globalViewModel)

            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            HStack {
//                Button {
//                    globalViewModel.restore()
//                } label: {
//                    Label("连抽", systemImage: "arrow.clockwise")
//                }
//                .buttonStyle(FloatingButtonStyle())

                Spacer()

                Button {
                    globalViewModel.restore()
                } label: {
                    Label("还原", systemImage: "arrow.clockwise")
                }
                .buttonStyle(FloatingButtonStyle())
            }
        }
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
