//
//  PointerShape.swift
//  Widget
//
//  Created by ailu on 2024/3/21.
//

import SwiftUI

struct PointerShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path {
            path in

            path.addArc(center: .init(x: rect.midX, y: rect.midY), radius: rect.width / 4, startAngle: .zero, endAngle: .radians(.pi * 2), clockwise: true)

            var trianglePath = Path()
            let w = rect.width / 8
            trianglePath.move(to: .init(x: rect.midX - w, y: rect.midY))
            trianglePath.addLine(to: .init(x: rect.midX + w, y: rect.midY))
            trianglePath.addLine(to: .init(x: rect.midX, y: rect.minY))
            trianglePath.closeSubpath()

            path.addPath(trianglePath)
        }
    }
}

#Preview {
    PointerShape()
//        .stroke(style: StrokeStyle(lineWidth: 8.0,lineCap: .round, lineJoin: .round))
        .fill(.blue)
        .frame(width: 400, height: 400)
        .background(.red.opacity(0.3))
}
