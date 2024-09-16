import Charts
import Defaults
import SwiftUI

struct ChartContent: View {
    var currentDecision: Decision

    var rawItems: [SpinCellItem]

    let radius: CGFloat

    init(currentDecision: Decision, radius: CGFloat) {
        self.currentDecision = currentDecision
        rawItems = currentDecision.sortedChoices.map { choice in
            SpinCellItem(id: choice.uuid, title: choice.title, weight: CGFloat(choice.weight4calc), enabled: choice.enable)
        }
        Logging.shared.debug("ChartContent init")
        self.radius = radius
    }

    @Default(.selectedSkinConfiguration)
    private var selectedSkinConfiguration

    var configuration: SpinWheelConfiguration {
        SkinManager.shared.getSkinConfiguration(skinKind: selectedSkinConfiguration)
    }

    var body: some View {
        let _ = Self._printChanges()

        SpinWheel(rawItems: rawItems,
                  size: CGSize(width: radius, height: radius),
                  configuration: configuration
        )
    }
}

let rawItems: [SpinCellItem] = [
    .init(id: UUID(), title: "item 1"),
    .init(id: UUID(), title: "item 2"),
    .init(id: UUID(), title: "item 3"),
    .init(id: UUID(), title: "item 4"),
    .init(id: UUID(), title: "item 5"),
    .init(id: UUID(), title: "item 6"),
    .init(id: UUID(), title: "item 7"),
    .init(id: UUID(), title: "item 8"),
]
