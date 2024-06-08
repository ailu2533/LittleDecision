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
        self.initialSpeed = Double.random(in: 150...200)
        self.decayFactor = Double.random(in: 0.9...0.99)
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
    @State private var isTimerActive = false  // 新增状态变量来跟踪计时器是否活跃

    var currentDecision: Decision
    @Binding var selection: Choice?

    let lotteryConfig = LotteryConfig()

    var body: some View {
        VStack {
//            Text(rotateAngle.formatted())
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

                            if !isTimerActive {  // 检查是否已有计时器在运行
                                isTimerActive = true  // 标记计时器为活跃状态
                                var currentSpeed = lotteryConfig.initialSpeed
                                var currentTime = 0.0

                                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                                    withAnimation {
                                        self.rotateAngle += currentSpeed
                                    }
                                    currentSpeed *= lotteryConfig.decayFactor // 逐渐减小增加的角度
                                    currentTime += 0.1

                                    let selectedChoice = LotteryViewModel.selectChoice(from: currentDecision.choices, basedOn: self.rotateAngle)

                                    withAnimation(.easeInOut) {
                                        selection = selectedChoice
                                    }

                                    if currentTime >= lotteryConfig.duration {
                                        timer.invalidate() // 停止计时器
                                        isTimerActive = false  // 重置计时器活跃状态
                                    }
                                }
                            }
                        }
                }

            Spacer()

            HStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        selection = nil
                        rotateAngle = rotateAngle - rotateAngle.truncatingRemainder(dividingBy: 360)
                    }

                    rotateAngle = 0
                    

                    
                }, label: {
                    Text("还原转盘")
                })
                Spacer()
            }
        }
    }
}

struct ChartView: View {
    var currentDecision: Decision
    @Binding var selection: Choice?

    var body: some View {
        Chart(currentDecision.choices) { choice in

            SectorMark(angle: .value(Text(verbatim: choice.title), Double(choice.weight)),
//                       innerRadius: .ratio(0.45),
                       outerRadius: choice.uuid == selection?.uuid ? 165 : 150,
                       angularInset: 1)

                .cornerRadius(12)
                .annotation(position: .overlay, alignment: .center) {
                    Text(choice.title)
                }

                .foregroundStyle(by: .value(Text(verbatim: choice.title), choice.title))
                .opacity(choice.choosed ? 0.1 : 1)
        }

        .chartLegend(.hidden)
    }
}

