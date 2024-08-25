//
//  TestRotation.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/24.
//

import SwiftUI


struct TestRotation: View {
    let mcalc = MathCalculation(innerRadius: 40, outerRadius: 350, weights: [2, 2, 2, 8])

    var body: some View {
        Circle()
            .fill(.blue.opacity(0.4))
            .frame(width: 700, height: 700)
            .overlay(alignment: .center, {
                Circle()
                    .fill(.green.opacity(0.8))
                    .frame(width: 80, height: 80)
            })
            .overlay(alignment: .center) {
                ForEach(mcalc.items) { item in

                    let size = item.rectSize(innerRadius: mcalc.innerRadius, outerRadius: mcalc.outerRadius)

                    Rectangle()
                        .fill(.red.opacity(0.8))
                        .frame(width: size.width, height: size.height)
                        .offset(x: mcalc.innerRadius + size.width / 2)
                        .rotationEffect(.radians(item.rotationDegrees))
                }
            }
    }
}

#Preview {
    TestRotation()
}
