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
    @Binding var selection: Choice?
    var currentDecision: Decision

    @State private var rotateAngle: Double = 0.0
    @State private var tapCount = 0
    @State private var isRunning = false

    @StateObject private var sound = SubsonicPlayer(sound: "8bit-canon-giulio-fazio-main-version-30900-02-48.mp3")

    @Default(.noRepeat) private var noRepeat
    @Default(.equalWeight) private var equalWeight
    @Default(.rotationTime) private var rotationTime

    @Default(.enableSound) private var enableSound

    @Default(.selectedThemeID) private var selectedThemeID

    @State private var deg: CGFloat = 0

    var body: some View {
        VStack {
            RotatingView(angle: rotateAngle) {
                ChartView(currentDecision: currentDecision, selection: selection)
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
            .id(currentDecision.hashValue & equalWeight.hashValue)

            Spacer()

            HStack {
                Spacer()
                RestoreButton(action: restore, tapCount: $tapCount)
                    .padding()
            }
        }
        .sensoryFeedback(.impact(flexibility: .soft), trigger: tapCount)
        .sensoryFeedback(.impact(flexibility: .rigid), trigger: isRunning) { $0 && !$1 }
    }

    private var pointerView: some View {
        PointerShape()
            .fill(.pink1)
            .stroke(.black, style: .init(lineWidth: 1))
            .overlay {
                PointerShape()
                    .fill(Material.thin)
            }

            .frame(width: 150, height: 150)
            .overlay(alignment: .center) {
                Text("开始")
                    .font(customStartFont)
                    .minimumScaleFactor(0.5)
                    .foregroundStyle(.black)
            }
    }

    private func restore() {
        if isRunning {
            return
        }

        withAnimation {
            selection = nil
            rotateAngle -= rotateAngle.truncatingRemainder(dividingBy: 360)
            currentDecision.choices.forEach { $0.enable = true }
        }
        currentDecision.wheelVersion += 1
        rotateAngle = 0
    }

    private func startSpinning() {
        guard !isRunning else { return }

        selection = nil

        if let (choice, angle) = LotteryViewModel.select(from: currentDecision.sortedChoices) {
            let extraRotation = rotationTime * 360.0
            let targetAngle = (270 - angle + 360 - rotateAngle.truncatingRemainder(dividingBy: 360)) + extraRotation

            isRunning = true

            if enableSound {
                sound.play()
            }

            withAnimation(.easeInOut(duration: rotationTime)) {
                rotateAngle += targetAngle

            } completion: {
                selection = choice
                if noRepeat {
                    selection?.decision?.updateDate = Date()
                    selection?.enable = false
                }

                isRunning = false

                if sound.isPlaying {
                    sound.stop()
                }
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
