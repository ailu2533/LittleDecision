import Charts
import Defaults
import SwiftUI

struct ChartView: View {
    var currentDecision: Decision
    var selection: Choice?

    init(currentDecision: Decision, selection: Choice?) {
        self.currentDecision = currentDecision
        self.selection = selection
        Logging.shared.debug("ChartView init ")
    }

    @Default(.fontSize) private var fontSize

    private static let chartColors: [Color] = [
        .pink.opacity(0.4), .pink.opacity(0.55),
    ]

    var colors: [Color] = [Color.pink.opacity(0.2), Color.pink.opacity(0.6)]
    let lineWidth: CGFloat = 2

    var body: some View {
        ZStack {
            circleBackground()
            chartContent()
        }
    }

    private func circleBackground() -> some View {
        Circle().fill(.white)
            .stroke(.black, style: .init(lineWidth: lineWidth))
            .shadow(radius: 2)
    }

    private func chartContent() -> some View {
        GeometryReader { proxy in
            let radius = min(proxy.size.width, proxy.size.height) / 2
            let innerRadius: CGFloat = max(radius / 5, 50)
            let trailingPadding: CGFloat = max(radius / 7, 12)

            ZStack {
                let weights = currentDecision.sortedChoices.map { CGFloat($0.weight) }
                let titles = currentDecision.sortedChoices.map { $0.title }
                let mcalc = MathCalculation(innerRadius: innerRadius, outerRadius: radius, weights: weights, titles: titles)

                ForEach(mcalc.items) { item in
                    SpinWheelCell(startAngle: item.startAngle, endAngle: item.endAngle)
                        .fill(colors[item.index % colors.count])
                        .stroke(Color.black, style: .init(lineWidth: lineWidth, lineJoin: .round))
                        .overlay {
                            chartItemText(item: item, innerRadius: innerRadius, outerRadius: radius, trailingPadding: trailingPadding)
                        }
                }
            }
        }
        .padding(8)
    }

    private func chartItemText(item: Item, innerRadius: CGFloat, outerRadius: CGFloat, trailingPadding: CGFloat) -> some View {
        let size = item.rectSize(innerRadius: innerRadius, outerRadius: outerRadius)
        return Text(item.title)
            .padding(.trailing, trailingPadding)
            .multilineTextAlignment(.trailing)
            .minimumScaleFactor(0.2)
            .lineLimit(3)
            .frame(width: size.width, height: size.height, alignment: .trailing)
            .offset(x: innerRadius + size.width / 2)
            .rotationEffect(.radians(item.rotationDegrees) + .pi / 2)
    }
}
