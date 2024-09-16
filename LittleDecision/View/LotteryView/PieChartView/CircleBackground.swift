//
//  CircleBackground.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/16.
//

import Foundation
import SwiftUI

struct CircleBackground: View {
    let lineWidth: CGFloat

    var body: some View {
        ZStack {
            Circle().fill(Color(.white))
                .stroke(.black, style: .init(lineWidth: lineWidth))
                .zIndex(3)
        }
    }
}
