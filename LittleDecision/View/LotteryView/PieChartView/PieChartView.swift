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
    // MARK: Internal

    var globalViewModel: GlobalViewModel

    var body: some View {
        let _ = Self._printChanges()

        VStack {
            GeometryReader { proxy in
                let radius = min(proxy.size.width, proxy.size.height)

                RotatingView(angle: rotateAngle) {
                    ZStack {
                        CircleBackground(lineWidth: 1)
                        ChartContent(choiceItems: globalViewModel.items, radius: radius)
                            .padding(12)
                    }
                }
                .overlay({
                    Button(action: {
                        tapCount += 1
                        startSpinning()
                    }, label: {
                        PointerView()
                    })

                    .buttonStyle(PointerViewButtonStyle())

                })
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            RestoreButton(action: restore, tapCount: $tapCount)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .sensoryFeedback(.impact(flexibility: .soft), trigger: tapCount)
        .sensoryFeedback(.impact(flexibility: .rigid), trigger: isRunning) { $0 && !$1 }
    }

    // MARK: Private

    @State private var rotateAngle: Double = 0.0
    @State private var tapCount = 0
    @State private var isRunning = false
}

extension PieChartView {
    private func restore() {
        if isRunning {
            return
        }

        withAnimation {
//            selection = nil
            globalViewModel.selectedChoice = nil
            rotateAngle -= rotateAngle.truncatingRemainder(dividingBy: 360)
//            currentDecision.unwrappedChoices.forEach { $0.enable = true }
        }
        rotateAngle = 0
    }

    private func startSpinning() {
        guard !isRunning else { return }
//
//        selection = nil
        globalViewModel.selectedChoice = nil
//
        if let (choice, angle) = LotteryViewModel.select(from: globalViewModel.items) {
            let extraRotation = Defaults[.rotationTime] * 360.0
            let targetAngle = (270 - angle + 360 - rotateAngle.truncatingRemainder(dividingBy: 360)) + extraRotation

            isRunning = true

            withAnimation(.easeInOut(duration: 3)) {
                rotateAngle += targetAngle

            } completion: {
                globalViewModel.selectedChoice = choice
                isRunning = false
            }
        } else {
            restore()
            isRunning = false
        }
    }
}
