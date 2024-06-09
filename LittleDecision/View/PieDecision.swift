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
    var duration = 4.0 // 总动画时间，单位秒
    var initialSpeed = 120.0 // 初始每次增加的角度
    var decayFactor = 0.95 // 速度衰减因子

    init() {
        // 随机设置
        // self.duration = Double.random(in: 2...4)
        initialSpeed = Double.random(in: 150 ... 200)
        decayFactor = Double.random(in: 0.9 ... 0.99)
    }
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
    @State private var rotateAngle: Double = 0.0
    @State private var isTimerActive = false
    @State private var isCalculating = false
    let lotteryConfig = LotteryConfig()
    @Binding var selection: Choice?
    var currentDecision: Decision

    var body: some View {
        VStack {
            ChartView(currentDecision: currentDecision, selection: $selection)
                .chartOverlay(alignment: .center) { _ in
                    PointerShape()
                        .fill(.white)
                        .shadow(radius: 1)
                        .rotationEffect(.degrees(rotateAngle))
                        .frame(width: 150, height: 150)
                        .overlay(alignment: .center) {
                            Text("开始")
                                .foregroundStyle(.black)
                        }.onTapGesture {
                            startSpinning()
                        }
                }
            Spacer()
            resetButton
        }
    }

    private var resetButton: some View {
        Button("还原转盘") {
            withAnimation {
                selection = nil
                rotateAngle = rotateAngle - rotateAngle.truncatingRemainder(dividingBy: 360)
                
            }
            rotateAngle = 0
        }
    }

    private func startSpinning() {
        guard !isTimerActive else { return }
        isTimerActive = true
        var currentSpeed = lotteryConfig.initialSpeed
        var currentTime = 0.0

        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            withAnimation {
                self.rotateAngle += currentSpeed
            }
            currentSpeed *= lotteryConfig.decayFactor
            currentTime += 0.1

            // 在这里调用选择逻辑
            DispatchQueue.global(qos: .userInitiated).async {
                let selectedChoice = LotteryViewModel.selectChoice(from: self.currentDecision.choices, basedOn: self.rotateAngle)
                DispatchQueue.main.async {
                    withAnimation(.easeInOut) {
                        self.selection = selectedChoice
                    }
                }
            }

            if currentTime >= lotteryConfig.duration {
                timer.invalidate()
                isTimerActive = false
            }
        }
    }
}

struct ChartView: View {
    var currentDecision: Decision
    @Binding var selection: Choice?

    var body: some View {
        Chart(currentDecision.choices) { choice in
            let isSelected = choice.uuid == selection?.uuid
            let outerRadius = isSelected ? 165 : 150
            let title = Text(verbatim: choice.title)

            SectorMark(angle: .value(Text(verbatim: choice.title), Double(choice.weight)),
//                       innerRadius: .ratio(0.45),
                       outerRadius: MarkDimension(integerLiteral: outerRadius),     
                       angularInset: 1)
                .cornerRadius(4)
                .annotation(position: .overlay, alignment: .center) {
                    title
                        .frame(maxWidth: 150)
                        .lineLimit(1) // 限制一行显示，避免文本溢出
                        .truncationMode(.tail) // 超出部分显示省略号
                }
                .foregroundStyle(by: .value(title, choice.title))
        }
        .chartLegend(.hidden) // 隐藏图例
    }
}

