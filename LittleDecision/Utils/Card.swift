//
//  Card.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/10/1.
//

import SwiftUI

struct Card: View {
    let size: CGSize
    var globalViewModel: GlobalViewModel

    var body: some View {
        Button {
            globalViewModel.flip()
        } label: {
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
        }
        .buttonStyle(.plain)
    }
}
