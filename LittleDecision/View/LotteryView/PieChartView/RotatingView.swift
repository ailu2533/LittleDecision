//
//  RotatingView.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/16.
//

import Foundation
import SwiftUI

struct RotatingView<Content: View>: View {
    let angle: Double
    let content: () -> Content

    var body: some View {
        content()
            .modifier(RotationModifier(angle: angle))
    }
}

struct RotationModifier: AnimatableModifier {
    var angle: Double

    var animatableData: Double {
        get { angle }
        set {
            angle = newValue
        }
    }

    func body(content: Content) -> some View {
        content.rotationEffect(.degrees(angle))
    }
}
