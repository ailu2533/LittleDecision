//
//  ChartView.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/16.
//

import Foundation
import SwiftUI

struct ChartView: View {
    var currentDecision: Decision
    var selection: Choice?

    var colors: [Color] = [Color.pink1, Color.white]

    var body: some View {
        ZStack {
            CircleBackground(lineWidth: 1)
            ChartContent(currentDecision: currentDecision, colors: colors)
                .padding(12)
        }
    }
}
