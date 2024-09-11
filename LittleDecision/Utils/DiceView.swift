//
//  DiceView.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/10.
//

import Foundation
import SwiftUI

enum DiceNum: Int, CaseIterable {
    case one, two, three, four, five, six

    var imageName: String { "\(self)" }

    var next: DiceNum {
        switch self {
        case .one:
            .two
        case .two:
            .three
        case .three:
            .four
        case .four:
            .five
        case .five:
            .six
        case .six:
            .one
        }
    }
}

struct DiceImage: View {
    let number: DiceNum

    var body: some View {
        Image(number.imageName)
            .resizable()
            .scaledToFit()
    }
}

struct DiceView: View {
    @State private var number: DiceNum = .two

    @State private var placeholder: DiceNum = .one

    @State private var angle: Angle = .zero
    @State private var isAnimating = false

    @State private var tapCount = 0

    var body: some View {
        Button {
            rollDice()

        } label: {
            DiceImage(number: number)
                .rotationEffect(angle)
        }
        .disabled(isAnimating)
        .sensoryFeedback(.impact, trigger: tapCount)
    }

    func rollDice() {
        isAnimating = true
        let steps = 8 // 每90度更新一次，总共16步

        func animate(step: Int) {
            guard step < steps else {
                isAnimating = false
                angle = .zero
                return
            }

            withAnimation(.linear(duration: 0.15)) {
                angle = .degrees(Double(step + 1) * 90)
            } completion: {
                tapCount += 1
                number = DiceNum.allCases.randomElement()!
                animate(step: step + 1)
            }
        }

        animate(step: 0)
    }
}
