//
//  PieChartNoRepeatView.swift
//  LittleDecision
//
//  Created by ailu on 2024/6/9.
//

import Combine
import Defaults
import Subsonic
import SwiftUI

struct PieChartView: View {
    var globalViewModel: GlobalViewModel
    var size: CGSize

    var radius: CGFloat {
        return min(size.width, size.height)
    }

    var body: some View {

        RotatingView(angle: globalViewModel.spinWheelRotateAngle) {
            ZStack {
                CircleBackground(lineWidth: 1)
                ChartContent(choiceItems: globalViewModel.items, radius: radius)
                    .padding(12)
            }
        }
        .overlay {
            Button {
                globalViewModel.go()
            } label: {
                PointerView()
            }
            .buttonStyle(PointerViewButtonStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
