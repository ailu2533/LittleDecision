//
//  Card.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/10/1.
//

import SwiftUI

struct Card: View {
//    var cardViewModel: CardViewModel
    let size: CGSize
    var globalViewModel: GlobalViewModel

    var body: some View {
        ZStack {
            CardFront(
                text: globalViewModel.deckText,
                rotationDegree: globalViewModel.deckFrontDegree,
                size: size
            )
            CardBack(
                rotationDegree: globalViewModel.deckBackDegree,
                size: size
            )
        }

        .onTapGesture {
            globalViewModel.flip()
        }
//        .sensoryFeedback(.impact, trigger: cardViewModel.tapCount)
    }
}
