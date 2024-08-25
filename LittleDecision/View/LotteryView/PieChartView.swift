//
//  PieChartNoRepeatView.swift
//  LittleDecision
//
//  Created by ailu on 2024/6/9.
//

import Combine
import Defaults
import SwiftUI

struct PieChartView: View {
    @Binding var selection: Choice?
    var currentDecision: Decision

    @State private var rotateAngle: Double = 0.0
    @State private var tapCount = 0
    @State private var isRunning = false

    @Default(.noRepeat) private var noRepeat
    @Default(.equalWeight) private var equalWeight
    @Default(.rotationTime) private var rotationTime

    @State private var deg: CGFloat = 0

    var body: some View {
        VStack {
            RotatingView(angle: rotateAngle) {
                ChartView(currentDecision: currentDecision, selection: selection)
            }
            .chartOverlay(alignment: .center) { _ in
                pointerView
            }
            .id(currentDecision.hashValue)

            Spacer()

            HStack {
                Spacer()
                RestoreButton(action: restore, tapCount: $tapCount)
                    .padding()
            }
        }
        .sensoryFeedback(.impact(flexibility: .solid), trigger: tapCount)
        .sensoryFeedback(.impact(flexibility: .rigid), trigger: isRunning) { $0 && !$1 }
    }

    private var pointerView: some View {
        PointerShape()
            .fill(.regularMaterial)
            .shadow(radius: 3)
            .frame(width: 150, height: 150)
            .overlay(alignment: .center) {
                Text("开始")
                    .foregroundStyle(.black)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
            }
            .onTapGesture {
                tapCount += 1
                startSpinning()
            }
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

        if let (choice, angle) = LotteryViewModel.select(from: currentDecision.sortedChoices) {
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

struct RotatingView<Content: View>: View {
    let angle: Double
    let content: () -> Content

    var body: some View {
        content()
            .modifier(RotationModifier(angle: angle))
    }
}

struct RotationModifier: AnimatableModifier {
    var angle: Double

    var animatableData: Double {
        get { angle }
        set {
            angle = newValue
        }
    }

    func body(content: Content) -> some View {
        content.rotationEffect(.degrees(angle))
    }
}
