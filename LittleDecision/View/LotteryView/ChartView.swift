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

            ZStack {
                let weights = currentDecision.sortedChoices.map { CGFloat($0.weight) }
                let titles = currentDecision.sortedChoices.map { $0.title }
                let selected = currentDecision.sortedChoices.map { $0.choosed }
                let mcalc = MathCalculation(innerRadius: innerRadius, outerRadius: radius, weights: weights, titles: titles, selected: selected)

                ForEach(mcalc.items.indices, id: \.self) { idx in
                    let item = mcalc.items[idx]
                    let choice = currentDecision.sortedChoices[idx]
                    SpinWheelCell2(item: item,
                                   choice: choice,
                                   colors: colors,
                                   lineWidth: lineWidth,
                                   innerRadius: innerRadius,
                                   outerRadius: radius,
                                   trailingPadding: trailingPadding,
                                   fontSize: fontSize)
                }
            }
        }
    }
}

struct SpinWheelCell2: View {
    let item: Item
    let choice: Choice
    let colors: [Color]
    let lineWidth: CGFloat
    let innerRadius: CGFloat
    let outerRadius: CGFloat
    let trailingPadding: CGFloat
    let fontSize: CGFloat

    var linearG: RadialGradient {
        RadialGradient(
            gradient: Gradient(colors: [.pink1, .white]),
            center: .center,
            startRadius: 0,
            endRadius: outerRadius
        )
    }

    var body: some View {
        SpinWheelCellShape(startAngle: .radians(item.startAngle), endAngle: .radians(item.endAngle))
            .fill(item.index % 2 == 0 ? linearG : .radialGradient(.init(colors: [Color.white]), center: .center, startRadius: 0, endRadius: outerRadius))
            .stroke(Color.black, style: .init(lineWidth: lineWidth, lineJoin: .round))
            .overlay {
                ChartItemText(item: item, selected: choice.enable, innerRadius: innerRadius, outerRadius: outerRadius, trailingPadding: trailingPadding, fontSize: fontSize)
            }
    }
}

struct SpinWheelCellShape: Shape {
    let startAngle: Angle
    let endAngle: Angle

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                    radius: rect.width / 2,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: false)
        path.addLine(to: CGPoint(x: rect.midX, y: rect.midY))
        path.closeSubpath()
        return path
    }
}

struct ChartItemText: View {
    let item: Item
    let selected: Bool
    let innerRadius: CGFloat
    let outerRadius: CGFloat
    let trailingPadding: CGFloat
    let fontSize: CGFloat

    var body: some View {
        let size = item.rectSize(innerRadius: innerRadius, outerRadius: outerRadius)
        return Text(item.title)
            .font(customBodyFont)
            .foregroundStyle(selected ? Color.black : Color.gray)
            .padding(.trailing, 12)
            .multilineTextAlignment(.trailing)
            .minimumScaleFactor(0.3)
            .lineLimit(3)
            .frame(width: size.width, height: size.height, alignment: .trailing)
            .offset(x: innerRadius + size.width / 2)
            .rotationEffect(.radians(item.rotationDegrees))
    }
}



