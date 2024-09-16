import Charts
import Defaults
import SwiftUI

struct ChartContent: View {
    var currentDecision: Decision
    var colors: [Color]

    @Default(.selectedSkinConfiguration)
    private var selectedSkinConfiguration

    var rawItems: [SpinCellRawItem] {
        _ = currentDecision.wheelVersion

        Logging.shared.debug("rawItems \(currentDecision.title)")
        return currentDecision.sortedChoices.map { choice in
            SpinCellRawItem(title: choice.title, weight: CGFloat(choice.weight4calc), enabled: choice.enable)
        }
    }

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
