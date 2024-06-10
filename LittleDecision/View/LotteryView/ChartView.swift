import Charts
import SwiftUI

struct ChartView: View {
    var currentDecision: Decision
    @Binding var selection: Choice?

    @State private var dict: [UUID: Double] = [:]

    @AppStorage("equalWeight") private var hideWeight = false

    var body: some View {
        Chart(currentDecision.choices) { choice in

            let title = Text(verbatim: choice.title).foregroundStyle(choice.enable ? .primary : Color.white)

            SectorMark(angle: .value(Text(verbatim: choice.title), Double(choice.weight4calc)),
                       angularInset: 1)
                .cornerRadius(4)
                .annotation(position: .overlay, alignment: .center) {
                    let rotationAngel = -90 + (dict[choice.uuid] ?? 90)

                    title
                        .frame(maxWidth: 150)
                        .lineLimit(1) // 限制一行显示，避免文本溢出
                        .truncationMode(.tail) // 超出部分显示省略号
                        .rotationEffect(.degrees(rotationAngel))
                }
                .foregroundStyle(by: .value(title, choice.uuid.uuidString))
        }
        .chartLegend(.hidden) // 隐藏图例
        .onAppear {
            dict = calculateAverageAngles()
        }
    }

    func calculateAverageAngles() -> [UUID: Double] {
        let totalWeight = currentDecision.choices.reduce(0) { $0 + $1.weight4calc }
        var angles = [UUID: Double]()
        var startAngle = 0.0

        for choice in currentDecision.choices {
            let weightProportion = Double(choice.weight4calc) / Double(totalWeight)
            let angle = weightProportion * 360.0
            let endAngle = startAngle + angle
            let averageAngle = (startAngle + endAngle) / 2
            angles[choice.uuid] = averageAngle
            startAngle = endAngle
        }

        return angles
    }
}