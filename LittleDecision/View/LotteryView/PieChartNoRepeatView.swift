//
//  PieChartNoRepeatView.swift
//  LittleDecision
//
//  Created by ailu on 2024/6/9.
//

import SwiftUI

struct PieChartNoRepeatView: View {
    @State private var rotateAngle: Double = 0.0
    @State private var isTimerActive = false
    @State private var isCalculating = false
    let lotteryConfig = LotteryConfig()
    @Binding var selection: Choice?
    var currentDecision: Decision

    @State private var tapCount = 0

    @State private var lastReportAngle = 0.0

    @State private var isRunning = false

    var body: some View {
        VStack {
            ChartView(currentDecision: currentDecision, selection: $selection)
                .chartOverlay(alignment: .center) { _ in
                    PointerShape()
                        .fill(.white)
                        .shadow(radius: 3)
                        .rotationEffect(.degrees(rotateAngle))

                        .frame(width: 150, height: 150)
                        .overlay(alignment: .center) {
                            Text("开始")
                                .foregroundStyle(.black)
                        }.onTapGesture {
                            tapCount += 1
                            startSpinning()
                        }
                }
            Spacer()
            
        }.sensoryFeedback(.impact(flexibility: .solid), trigger: tapCount)
            .sensoryFeedback(.impact(flexibility: .rigid), trigger: isRunning) { oldValue, newValue in
                oldValue && !newValue
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("还原转盘") {
                        restore()
                        tapCount += 1
                    }
                }
            })
    }

    private func restore() {
        withAnimation {
            selection = nil
            rotateAngle = rotateAngle - rotateAngle.truncatingRemainder(dividingBy: 360)

            currentDecision.choices.forEach { choice in
                choice.enable = true
            }
        }
        rotateAngle = 0
    }

    private func startSpinning() {
        if isRunning {
            return
        }

        isRunning = true

        selection = nil

        if let (choice, angle) = LotteryViewModel.selectChoiceExcludeDisable(from: currentDecision.choices) {
            withAnimation(.smooth(duration: 4)) {
                self.rotateAngle += (angle + 360 - self.rotateAngle.truncatingRemainder(dividingBy: 360) + 4 * 360)
            } completion: {
                selection = choice
                selection?.enable = false

                isRunning = false
            }
        } else {
            restore()
            isRunning = false
        }
    }
}
