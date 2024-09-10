//
//  CardView.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/10.
//

import SwiftUI

struct CardView: View {
    var text: String
    var isShuffling: Bool

    var size: CGSize

    var body: some View {
        let _ = Self._printChanges()
        Text(text)
            .padding()
            .frame(width: size.width, height: size.height)
            .background {
                Image(.background)
                    .resizable()
                    .scaledToFill()
            }
            .overlay(content: {
                if isShuffling {
                    Image(.cardbackYellow)
                        .resizable()
                        .scaledToFill()
                }
            })
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .font(.title)
            .fontWeight(.semibold)
            .shadow(radius: 1)
    }
}
