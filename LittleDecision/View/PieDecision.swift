//
//  PieChartView.swift
//  Widget
//
//  Created by ailu on 2024/3/21.
//

import Charts
import Combine
import SwiftData
import SwiftUI

struct PieChartView: View {
    @State private var selectedCount: Double?
    @State private var randomNumber: Double = 0.0
    @State private var rotateAngle: Double = 0.0

    var currentDecision: Decision
    @Binding var selection: Choice?

    var body: some View {
        VStack {
            Chart(currentDecision.sortedChoices) { choice in

                SectorMark(angle: .value(Text(verbatim: choice.title), Double(choice.weight)),
                           innerRadius: .ratio(0.45),
                           outerRadius: choice.uuid == selection?.uuid ? 165 : 150,
                           angularInset: 1)

                    .cornerRadius(12)
                    .annotation(position: .overlay, alignment: .center) {
                        Text(choice.title)
                    }

                    .foregroundStyle(by: .value(Text(verbatim: choice.title), choice.title))
                    .opacity(choice.choosed ? 0.1 : 1)

            }.chartAngleSelection(value: $selectedCount)
                .chartOverlay { chartProxy in

                    GeometryReader { geometry in

                        let frame = geometry[chartProxy.plotFrame!]

                        PointerShape()

                            .fill(.blue.opacity(0.8))
                            .rotationEffect(.degrees(rotateAngle))
                            .frame(width: 150, height: 150)
                            .position(x: frame.midX, y: frame.midY)
                            .overlay(alignment: .center) {
                                Text("开始")
                                    .foregroundStyle(.black)
                                    .position(x: frame.midX, y: frame.midY)
                            }.onTapGesture {
                                rotateAngle += 50
                            }
                    }
                }.chartLegend(.hidden)
        }
    }
}
