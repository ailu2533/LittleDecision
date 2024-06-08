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

struct LotteryConfig {
    static let duration = 4.0 // 总动画时间，单位秒
    static let initialSpeed = 120.0 // 初始每次增加的角度
    static let decayFactor = 0.95 // 速度衰减因子
}

class LotteryViewModel {
    static func selectChoice(from choices: [Choice], basedOn rotateAngle: Double) -> Choice? {
        let totalWeight = choices.reduce(0) { $0 + $1.weight }
        if totalWeight == 0 { return nil } // 防止除以零的错误

        // 计算每个 choice 的角度范围
        var angles = [Double]()
        var cumulativeAngle = 0.0

        for choice in choices {
            let angle = (Double(choice.weight) / Double(totalWeight)) * 360
            cumulativeAngle += angle
            angles.append(cumulativeAngle)
        }

        // 根据 rotateAngle 确定选中的 choice
        let adjustedAngle = rotateAngle.truncatingRemainder(dividingBy: 360)

        // 使用二分查找来确定 adjustedAngle 落在哪个区间
        var low = 0
        var high = angles.count - 1

        while low <= high {
            let mid = (low + high) / 2
            if adjustedAngle < angles[mid] {
                if mid == 0 || adjustedAngle >= angles[mid - 1] {
                    return choices[mid]
                }
                high = mid - 1
            } else {
                low = mid + 1
            }
        }

        return nil // 如果没有找到，理论上不应该发生
    }
}

struct PieChartView: View {
    @State private var selectedCount: Double?
    @State private var randomNumber: Double = 0.0
    @State private var rotateAngle: Double = 0.0

    var currentDecision: Decision
    @Binding var selection: Choice?

    var body: some View {
        VStack {
            Text(selection?.title ?? "无")
//            Text(rotateAngle.formatted())
            ChartView(currentDecision: currentDecision, selection: $selection)
                .chartOverlay(alignment: .center) { _ in
                    PointerShape()

                        .fill(.blue.opacity(0.8))
                        .rotationEffect(.degrees(rotateAngle))
                        .frame(width: 150, height: 150)
                        .overlay(alignment: .center) {
                            Text("开始")
                                .foregroundStyle(.black)
                        }.onTapGesture {
                            selection = nil

                            var currentSpeed = LotteryConfig.initialSpeed
                            var currentTime = 0.0

                            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                                withAnimation {
                                    self.rotateAngle += currentSpeed
                                }
                                currentSpeed *= LotteryConfig.decayFactor // 逐渐减小增加的角度
                                currentTime += 0.1

                                withAnimation(.easeInOut) {
                                    selection = LotteryViewModel.selectChoice(from: currentDecision.choices, basedOn: self.rotateAngle)
                                }

                                if currentTime >= LotteryConfig.duration {
                                    timer.invalidate() // 停止计时器
                                    
                                }
                            }
                        }
                }
        }
    }
}

struct ChartView: View {
    var currentDecision: Decision
    @Binding var selection: Choice?
    @State private var selectedCount: Double?

    var body: some View {
        Chart(currentDecision.choices) { choice in

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

            .chartLegend(.hidden)
    }
}
