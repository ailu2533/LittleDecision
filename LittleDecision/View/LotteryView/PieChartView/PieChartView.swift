//
//  PieChartNoRepeatView.swift
//  LittleDecision
//
//  Created by ailu on 2024/6/9.
//

import Combine
import Defaults
import Subsonic
import SwiftUI

struct PieChartView: View {
    var globalViewModel: GlobalViewModel

    var body: some View {
        let _ = Self._printChanges()

        GeometryReader { proxy in
            let radius = min(proxy.size.width, proxy.size.height)

            RotatingView(angle: globalViewModel.spinWheelRotateAngle) {
                ZStack {
                    CircleBackground(lineWidth: 1)
                    ChartContent(choiceItems: globalViewModel.items, radius: radius)
                        .padding(12)
                }
            }
            .overlay {
                Button {
                    globalViewModel.startSpinning()
                } label: {
                    PointerView()
                }
                .buttonStyle(PointerViewButtonStyle())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .sensoryFeedback(.impact(flexibility: .soft), trigger: tapCount)
//        .sensoryFeedback(.impact(flexibility: .rigid), trigger: isRunning) { $0 && !$1 }
    }
}
