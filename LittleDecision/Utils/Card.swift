//
//  Card.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/10/1.
//

import SwiftUI

struct Card: View {
    var cardViewModel: CardViewModel
    let size: CGSize

    var body: some View {
        ZStack {
            CardFront(
                text: cardViewModel.text,
                rotationDegree: cardViewModel.frontDegree,
                size: size
            )
            CardBack(
                rotationDegree: cardViewModel.backDegree,
                size: size,
                enableWiggle: cardViewModel.enableWiggle
            )
        }
        .scaleEffect(cardViewModel.isScaled ? 1 : kScale)
        .offset(x: cardViewModel.xOffset)
        .onTapGesture {
            cardViewModel.flip()
        }
        .sensoryFeedback(.impact, trigger: cardViewModel.tapCount)
    }
}
