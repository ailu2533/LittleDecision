import Charts
import Defaults
import SwiftUI

struct ChartView: View {
    var currentDecision: Decision
    var selection: Choice?

    var colors: [Color] = [Color.pink1, Color.white]

    var body: some View {
        ZStack {
            CircleBackground(lineWidth: 1)
            ChartContent(currentDecision: currentDecision, colors: colors)
                .padding(12)
        }
    }
}

struct CircleBackground: View {
    let lineWidth: CGFloat

    var body: some View {
        ZStack {
            Circle().fill(.netureWhite)
                .stroke(.netureBlack, style: .init(lineWidth: lineWidth))
//                .shadow(radius: 2)
//                .padding(12)
                .zIndex(3)

//            Circle().stroke(Color.gray, style: .init(lineWidth: 3, dash: [7, 8]))
//                .padding(6)
//                .zIndex(2)

//            Circle().fill(.white)
//                .stroke(.black, style: .init(lineWidth: lineWidth))
////                .shadow(radius: 2)
//                .zIndex(1)
        }
    }
}

struct ChartContent: View {
    var currentDecision: Decision
    var colors: [Color]

    @Default(.selectedSkinConfiguration)
    private var selectedSkinConfiguration

    var rawItems: [SpinCellRawItem] {
        _ = currentDecision.wheelVersion
        return currentDecision.sortedChoices.map { choice in
            SpinCellRawItem(title: choice.title, weight: CGFloat(choice.weight4calc), enabled: choice.enable)
        }
    }

    var configuration: SpinWheelConfiguration {
        SkinManager.shared.getSkinConfiguration(skinKind: selectedSkinConfiguration)
    }

    var body: some View {
        GeometryReader { proxy in

            SpinWheel(rawItems: rawItems,
                      size: proxy.size,
                      configuration: configuration
            )
        }
    }
}

let rawItems: [SpinCellRawItem] = [
    .init(title: "item 1"),
    .init(title: "item 2"),
    .init(title: "item 3"),
    .init(title: "item 4"),
    .init(title: "item 5"),
    .init(title: "item 6"),
    .init(title: "item 7"),
    .init(title: "item 8"),
]

struct SpinWheelPreview: View {
    var skinKind: SkinKind

    private var configuration: SpinWheelConfiguration {
        SkinManager.shared.getSkinConfiguration(skinKind: skinKind)
    }

    var body: some View {
        GeometryReader { proxy in

            SpinWheel(rawItems: rawItems,
                      size: proxy.size,
                      configuration: configuration
            )
        }
    }
}
