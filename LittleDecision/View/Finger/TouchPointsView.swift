//
//  TouchPointsView.swift
//  LittleDecision
//
//  Created by ailu on 2024/6/8.
//

import UIKit


class TouchPointsView: UIView {
    var touchPoints: [CGPoint] = []
    var timer: Timer?
    var shouldDisplayPoints = false

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touchPoints.append(contentsOf: touches.map { $0.location(in: self) })
        updateDisplayOfTouchPoints()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        touchPoints.append(contentsOf: touches.map { $0.location(in: self) })
        updateDisplayOfTouchPoints()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        touchPoints.removeAll { point in touches.map { $0.location(in: self) }.contains(point) }
        updateDisplayOfTouchPoints()
    }

    private func updateDisplayOfTouchPoints() {
        if touchPoints.count > 1 {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] _ in
                self?.shouldDisplayPoints = true
                self?.setNeedsDisplay()
            }
        } else {
            timer?.invalidate()
            shouldDisplayPoints = false
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(), shouldDisplayPoints else { return }
        context.clear(rect)

        for point in touchPoints {
            context.setFillColor(UIColor.blue.cgColor)
            context.fillEllipse(in: CGRect(x: point.x - 15, y: point.y - 15, width: 30, height: 30))
        }
    }
}
