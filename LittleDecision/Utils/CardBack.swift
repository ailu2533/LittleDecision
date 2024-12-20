//
//  CardBack.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/10/1.
//

import SwiftUI

struct CardBack: View {
    var rotationDegree: CGFloat = .zero
    let size: CGSize

    var body: some View {
        Image(.cardBack)
            .resizable()
            .scaledToFill()
            .frame(width: size.width, height: size.height)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(radius: 1)
            .rotation3DEffect(
                .degrees(rotationDegree),
                axis: (x: 0.0, y: 1.0, z: 0.001),
                perspective: 0
            )
//            .rotationEffect(.degrees(enableWiggle ? 2.5 : 0))
    }
}
