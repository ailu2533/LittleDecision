//
//  PointerShape.swift
//  Widget
//
//  Created by ailu on 2024/3/21.
//

import SwiftUI

struct PointerShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: .init(x: rect.midX, y: rect.midY), radius: rect.width / 4, startAngle: .zero, endAngle: .radians(CGFloat.pi * 2), clockwise: true)

        var trianglePath = Path()
        let width = rect.width / 4
        trianglePath.move(to: .init(x: rect.midX - width, y: rect.midY))
        trianglePath.addLine(to: .init(x: rect.midX + width, y: rect.midY))
        trianglePath.addLine(to: .init(x: rect.midX, y: rect.minY + width / 2))
        trianglePath.closeSubpath()

        return path.union(trianglePath)
    }
}
