//
//  SpinWheelConfiguration.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/31.
//

import Foundation

struct SpinWheelConfiguration: Identifiable {
    var id: SkinKind {
        skinKind
    }

    var skinKind: SkinKind

    var fills: [SectionFill]

    var cellLineWidth: CGFloat = 1

    var isPremium: Bool = true

    func radius(size: CGSize) -> CGFloat {
        return min(size.width, size.height) / 2
    }

    func innerRadius(size: CGSize) -> CGFloat {
        let radius = radius(size: size)
        return max(radius / 5, 50)
    }

    func trailingPadding(size: CGSize) -> CGFloat {
        let radius = radius(size: size)
        return min(max(radius / 12, 10), 20)
    }
}
