import Charts
import Defaults
import SwiftUI

struct ChartView: View {
    var currentDecision: Decision
    @Binding var selection: Choice?

    @Default(.fontSize) private var fontSize

    @State private var dict: [UUID: Double] = [:]

    var body: some View {
        let maxWidth = (UIScreen.main.bounds.width - 150) / 2

        Chart(currentDecision.choices) { choice in

            let title = Text(verbatim: choice.title).foregroundStyle(choice.enable ? .primary : Color.white)
                .font(.system(size: fontSize))

            SectorMark(angle: .value(Text(verbatim: choice.title), Double(choice.weight4calc)),
                       angularInset: 1)
                .cornerRadius(8)
                .annotation(position: .overlay, alignment: .center) {
                    let rotationAngel = (dict[choice.uuid] ?? 0)

                    title
                        .frame(maxWidth: maxWidth)
                        .rotationEffect(.degrees(rotationAngel))
                        .minimumScaleFactor(0.5)
                        .lineLimit(4)
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

            var rotation = 0.0
            if averageAngle <= 180 {
                rotation = -90.0 + averageAngle
            } else if averageAngle <= 270 {
                rotation = -90 + averageAngle + 180
            } else {
                rotation = -90.0 + averageAngle - 180
            }

            angles[choice.uuid] = rotation
            startAngle = endAngle
        }

        return angles
    }
}
