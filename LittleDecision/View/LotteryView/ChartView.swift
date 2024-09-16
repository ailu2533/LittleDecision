import Charts
import Defaults
import SwiftUI

struct ChartContent: View {
    var currentDecision: Decision

    @Default(.equalWeight)
    private var equalWeight

    var rawItems: [SpinCellRawItem] {
        currentDecision.sortedChoices.map { choice in
            SpinCellRawItem(title: choice.title, weight: CGFloat(equalWeight ? 1 : choice.weight), enabled: choice.enable)
        }
    }

    init(currentDecision: Decision) {
        self.currentDecision = currentDecision
    }

    @Default(.selectedSkinConfiguration)
    private var selectedSkinConfiguration

    var configuration: SpinWheelConfiguration {
        SkinManager.shared.getSkinConfiguration(skinKind: selectedSkinConfiguration)
    }

    var body: some View {
        let _ = Self._printChanges()

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
