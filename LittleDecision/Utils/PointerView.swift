//
//  PointerView.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/30.
//

import Foundation
import SwiftUI
import SpinWheel

struct PointerView: View {
    var body: some View {
        ZStack {
            PointerShape()
                .fill(RadialGradient(colors: [.pink2, .white], center: .center, startRadius: 0, endRadius: 150))
                .shadow(radius: 1)
            Text("开始")
                .font(customStartFont)
                .minimumScaleFactor(0.5)
                .foregroundColor(.black)
        }
        .frame(width: 150, height: 150)
    }
}

struct PointerViewButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

#Preview {
    Button(action: {}, label: {
        PointerView()
    })
    .buttonStyle(PointerViewButtonStyle())
}
