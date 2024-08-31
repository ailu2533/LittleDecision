import Charts
import Defaults
import SwiftUI

struct ChartView: View {
    var currentDecision: Decision
    var selection: Choice?
    @Default(.fontSize) private var fontSize

    var colors: [Color] = [Color.pink1, Color.white]
    let lineWidth: CGFloat = 2

    var body: some View {
        ZStack {
            CircleBackground(lineWidth: lineWidth)
            ChartContent(currentDecision: currentDecision, colors: colors, lineWidth: lineWidth, fontSize: fontSize)
                .padding(24)
        }
    }
}

struct CircleBackground: View {
    let lineWidth: CGFloat

    var body: some View {
        ZStack {
            Circle().fill(.pink1)
                .stroke(.black, style: .init(lineWidth: lineWidth))
                .shadow(radius: 2)
                .padding(12)
                .zIndex(3)

            Circle().stroke(Color.gray, style: .init(lineWidth: 3, dash: [7, 8]))
                .padding(6)
                .zIndex(2)

            Circle().fill(.white)
                .stroke(.black, style: .init(lineWidth: lineWidth))
                .shadow(radius: 2)
                .zIndex(1)
        }
    }
}

struct ChartContent: View {
    var currentDecision: Decision
    var colors: [Color]
    let lineWidth: CGFloat
    let fontSize: CGFloat

    var body: some View {
        GeometryReader { proxy in
            let radius = min(proxy.size.width, proxy.size.height) / 2
            let innerRadius: CGFloat = max(radius / 5, 50)
            let trailingPadding: CGFloat = max(radius / 7, 12)

            let weights = currentDecision.sortedChoices.map { CGFloat($0.weight) }
            let titles = currentDecision.sortedChoices.map { $0.title }
            let selected = currentDecision.sortedChoices.map { $0.choosed }

            SpinWheel(weights: weights,
                      titles: titles,
                      selected: selected,
                      radius: radius,
                      innerRadius: innerRadius,
                      colors: colors,
                      lineWidth: lineWidth,
                      trailingPadding: trailingPadding
            )
        }
    }
}
