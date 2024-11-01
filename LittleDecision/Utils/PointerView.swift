//
//  PointerView.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/30.
//

import Foundation
import SpinWheel
import SwiftUI

// MARK: - PointerView

struct PointerView: View {
    var body: some View {
        ZStack {
            PointerShape()
                .shadow(radius: 1)
                .foregroundStyle(.white)
            Text(verbatim: "Go")
                .fontDesign(.rounded)
                .fontWeight(.bold)
                .foregroundStyle(.black)
        }
        .frame(width: 150, height: 150)
    }
}

// MARK: - PointerViewButtonStyle

struct PointerViewButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
