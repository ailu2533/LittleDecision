//
//  PieChartView.swift
//  Widget
//
//  Created by ailu on 2024/3/21.
//

import Charts
import Combine
import SwiftData
import SwiftUI


struct PieChartView: View {
    @State private var rotateAngle: Double = 0.0
    @State private var isTimerActive = false
    @State private var isCalculating = false
    let lotteryConfig = LotteryConfig()
    @Binding var selection: Choice?
    var currentDecision: Decision

    var body: some View {
        VStack {
            ChartView(currentDecision: currentDecision, selection: $selection)
                .chartOverlay(alignment: .center) { _ in
                    PointerShape()
                        .fill(.white)
                        .shadow(radius: 1)
                        .rotationEffect(.degrees(rotateAngle))
                        .frame(width: 150, height: 150)
                        .overlay(alignment: .center) {
                            Text("开始")
                                .foregroundStyle(.black)
                        }.onTapGesture {
                            startSpinning()
                        }
                }
            Spacer()
            resetButton
        }
    }

    private var resetButton: some View {
        Button("还原转盘") {
            withAnimation {
                selection = nil
                rotateAngle = rotateAngle - rotateAngle.truncatingRemainder(dividingBy: 360)
            }
            rotateAngle = 0
        }
    }

    private func startSpinning() {
        guard !isTimerActive else { return }
        isTimerActive = true
        var currentSpeed = lotteryConfig.initialSpeed
        var currentTime = 0.0

        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            withAnimation {
                self.rotateAngle += currentSpeed
            }
            currentSpeed *= lotteryConfig.decayFactor
            currentTime += 0.1

            // 在这里调用选择逻辑
            DispatchQueue.global(qos: .userInitiated).async {
                let selectedChoice = LotteryViewModel.selectChoice(from: self.currentDecision.choices, basedOn: self.rotateAngle)
                DispatchQueue.main.async {
                    withAnimation(.easeInOut) {
                        self.selection = selectedChoice
                    }
                }
            }

            if currentTime >= lotteryConfig.duration {
                timer.invalidate()
                isTimerActive = false
            }
        }
    }
}

