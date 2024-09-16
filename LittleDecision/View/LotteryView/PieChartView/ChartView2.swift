//
//  ChartView.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/16.
//

import Defaults
import Foundation
import SwiftUI

struct ChartView: View {
    var currentDecision: Decision
    let radius: CGFloat

    @Default(.equalWeight)
    private var equalWeight

    var body: some View {
        ZStack {
            CircleBackground(lineWidth: 1)
            ChartContent(currentDecision: currentDecision, radius: radius)
                .padding(12)
        }
        .id(equalWeight)
    }
}
