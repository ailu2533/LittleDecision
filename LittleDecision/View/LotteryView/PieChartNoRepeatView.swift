//
//  PieChartNoRepeatView.swift
//  LittleDecision
//
//  Created by ailu on 2024/6/9.
//

import SwiftUI

struct PieChartNoRepeatView: View {
    @Binding var selection: Choice?
    var currentDecision: Decision

    @State private var rotateAngle: Double = 0.0
    @State private var tapCount = 0
    @State private var isRunning = false

    @AppStorage("noRepeat") private var noRepeat = false
    @AppStorage("equalWeight") private var equalWeight = false
    @AppStorage("rotationTime") private var rotationTime: Double = 4

    var body: some View {
        VStack {
            ChartView(currentDecision: currentDecision, selection: $selection)
                .chartOverlay(alignment: .center) { _ in
                    pointerView
                }
            Spacer()
        }
        .sensoryFeedback(.impact(flexibility: .solid), trigger: tapCount)
        .sensoryFeedback(.impact(flexibility: .rigid), trigger: isRunning) { $0 && !$1 }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                restoreButton
            }
        }
    }

    private var pointerView: some View {
        PointerShape()
            .fill(.white)
            .shadow(radius: 3)
            .rotationEffect(.degrees(rotateAngle))
            .frame(width: 150, height: 150)
            .overlay(alignment: .center) {
                Text("开始")
                    .foregroundStyle(.black)
            }
            .onTapGesture {
                tapCount += 1
                startSpinning()
            }
    }

    private var restoreButton: some View {
        Button(action: {
            restore()
            tapCount += 1
        }, label: {
            Label("还原转盘", systemImage: "arrow.clockwise")
        })
    }

    private func restore() {
        withAnimation {
            selection = nil
            rotateAngle -= rotateAngle.truncatingRemainder(dividingBy: 360)
            currentDecision.choices.forEach { $0.enable = true }
        }
        rotateAngle = 0
    }

    private func startSpinning() {
        guard !isRunning else { return }

        isRunning = true
        selection = nil

        if let (choice, angle) = LotteryViewModel.select(from: currentDecision.choices) {
            let extraRotation = rotationTime * 360.0
            let targetAngle = (angle + 360 - rotateAngle.truncatingRemainder(dividingBy: 360)) + extraRotation

            withAnimation(.smooth(duration: rotationTime)) {
                rotateAngle += targetAngle
            } completion: {
                selection = choice
                if noRepeat { selection?.enable = false }
                isRunning = false
            }
        } else {
            restore()
            isRunning = false
        }
    }
}
