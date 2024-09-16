//
//  Item.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/16.
//

import Foundation
import UIKit

struct Item: Identifiable {
    var id: Int {
        index
    }

    // 第几个数据
    let index: Int
    // 被抽中的权重
    let weight: CGFloat
    let title: String
    let enabled: Bool
    // 数据在转盘中的圆弧对应角度范围, 单位弧度制
    let startAngle: CGFloat
    let endAngle: CGFloat

    func calculateTextSize(text: String, font: UIFont, maxWidth: CGFloat) -> CGSize {
        let constraintRect = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font],
                                            context: nil)
        return boundingBox.size
    }

    public func idealSize(innerRadius: CGFloat, outerRadius: CGFloat) -> CGSize? {
        let textSize = calculateTextSize(text: title, font: customBodyUIFont, maxWidth: outerRadius)
        let halfHeight = textSize.height / 2
        // 计算width，并确保它不是负数
        let squaredDifference = max(outerRadius * outerRadius - halfHeight * halfHeight, 0)
        let width = sqrt(squaredDifference) - innerRadius
        if width >= textSize.width {
            return .init(width: width, height: textSize.height)
        }

        return nil
    }

    public func rectSize(innerRadius: CGFloat, outerRadius: CGFloat) -> CGSize {
//        if let isize = idealSize(innerRadius: innerRadius, outerRadius: outerRadius) {
//            return isize
//        }

        var alpha = endAngle - startAngle

        // 限制alpha的范围
        alpha = min(max(alpha, 0), .pi / 2)

        let halfHeight = innerRadius * tan(alpha / 2)

        // 计算width，并确保它不是负数
        let squaredDifference = max(outerRadius * outerRadius - halfHeight * halfHeight, 0)
        let width = sqrt(squaredDifference) - innerRadius

//        let textSize = calculateTextSize(text: title, font: customBodyUIFont, maxWidth: width)
//        if textSize.height > max(2 * halfHeight, 0) {
//            let half = textSize.height / 2
//
//            let squaredDifference = max(outerRadius * outerRadius - half * half, 0)
//            let width = sqrt(squaredDifference) - innerRadius
//
//            // 使用max函数确保width和height都不小于0
//            return CGSize(
//                width: max(width, 0),
//                height: max(2 * half, 0)
//            )
//        }

        // 使用max函数确保width和height都不小于0
        return CGSize(
            width: max(width, 0),
            height: max(2 * halfHeight, 0)
        )
    }

    var rotationDegrees: CGFloat {
        let avgAngle = (startAngle + endAngle) / 2
        return avgAngle
    }
}
