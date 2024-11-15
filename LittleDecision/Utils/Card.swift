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

    var text: String {
        return globalViewModel.selectedChoice?.content ?? String(localized: "选项用完了，点击还原继续")
    }

    var body: some View {
        Button {
            globalViewModel.flip()
        } label: {
            ZStack {
                CardFront(
                    text: text,
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
