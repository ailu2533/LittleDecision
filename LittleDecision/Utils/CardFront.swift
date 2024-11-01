//
//  CardFront.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/10/1.
//

import SwiftUI

struct CardFront: View {
    let text: String
    var rotationDegree: CGFloat = .zero
    let size: CGSize

    var body: some View {
        Text(text)
            .padding()
            .frame(width: size.width, height: size.height)
//            .font(customBodyFont)
//            .foregroundStyle(Color.black)
            .background {
                Image(.background)
                    .resizable()
                    .scaledToFill()
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(radius: 1)

            .rotation3DEffect(
                .degrees(rotationDegree),
                axis: (x: 0.0, y: 1.0, z: 0.001),
                perspective: 0
            )
    }
}
