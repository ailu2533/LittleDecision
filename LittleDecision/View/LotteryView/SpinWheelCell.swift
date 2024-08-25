//
//  SpinWheelCell.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/25.
//

import SwiftUI

struct SpinWheelCell: Shape {
    let startAngle: Double, endAngle: Double

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius = min(rect.width, rect.height) / 2
        let alpha = CGFloat(startAngle)
        let center = CGPoint(
            x: rect.midX,
            y: rect.midY
        )
        path.move(to: center)
        path.addLine(
            to: CGPoint(
                x: center.x + cos(alpha) * radius,
                y: center.y + sin(alpha) * radius
            )
        )
        path.addArc(
            center: center, radius: radius,
            startAngle: Angle(radians: startAngle),
            endAngle: Angle(radians: endAngle),
            clockwise: false
        )

        path.closeSubpath()
        return path
    }
}

@Observable
class SpinWheelViewModel {
    var items: [Item] = []
    var innerRadius: CGFloat
    var outerRadius: CGFloat
    var colors: [Color] = [Color.pink.opacity(0.2), Color.pink.opacity(0.6), Color.pink.opacity(0.8)]

    init(items: [Item], innerRadius: CGFloat, outerRadius: CGFloat) {
        self.items = items
        self.innerRadius = innerRadius
        self.outerRadius = outerRadius
    }
}

struct CustomPieChart1: View {
    let colors: [Color] = [Color.pink.opacity(0.2), Color.pink.opacity(0.6), Color.pink.opacity(0.8)]

    let mcalc = MathCalculation(innerRadius: 20, outerRadius: 150, weights: [1, 1, 1, 1, 2], titles: ["1", "2", "2", "4", "5"])
    var body: some View {
        ZStack {
            ForEach(mcalc.items) { item in
                SpinWheelCell(startAngle: item.startAngle, endAngle: item.endAngle)
                    .fill(colors[item.index % colors.count])
                    .stroke(Color.black, style: .init(lineWidth: 4, lineJoin: .round))
                    .overlay {
                        let size = item.rectSize(innerRadius: 20, outerRadius: 150)
                        Text("hello")
                            .frame(width: size.width, height: size.height, alignment: .trailing)
                            .offset(x: 20 + size.width / 2)
                            .rotationEffect(.radians(item.rotationDegrees) + .pi / 2)
                    }
            }
        }
    }
}

#Preview {
    CustomPieChart1()
}
