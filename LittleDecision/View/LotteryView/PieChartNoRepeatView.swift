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

    @State private var lastReportAngle = 0.0

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
        selection = nil
        withAnimation(.smooth(duration: 4)) {
            self.rotateAngle += 2150
        } completion: {
            selection = LotteryViewModel.selectChoice(from: currentDecision.choices, basedOn: self.rotateAngle)
        }

    }
}
