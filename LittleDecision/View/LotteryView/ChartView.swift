import Charts
import Defaults
import SpinWheel
import SwiftUI

struct ChartContent: View {
    var currentDecision: Decision
    let radius: CGFloat

    init(currentDecision: Decision, radius: CGFloat) {
        self.currentDecision = currentDecision
        Logging.shared.debug("ChartContent init")
        self.radius = radius
    }

    @Default(.selectedSkinConfiguration)
    private var selectedSkinConfiguration

    @Default(.equalWeight)
    private var equalWeight

    @Default(.noRepeat)
    private var noRepeat

    var configuration: SpinWheelConfiguration {
        SkinManager.shared.getSkinConfiguration(skinKind: selectedSkinConfiguration)
    }

    var spinCellItems: [SpinCellItem] {
        _ = currentDecision.wheelVersion
        _ = equalWeight
        return currentDecision.sortedChoices.map { choice in
            SpinCellItem(id: choice.uuid, title: choice.title, weight: CGFloat(choice.weight4calc), enabled: choice.enable)
        }
    }

    var body: some View {
        let _ = Self._printChanges()

        SpinWheel(rawItems: spinCellItems,
                  size: CGSize(width: radius, height: radius),
                  configuration: configuration
        )
        .onChange(of: noRepeat) { _, _ in
            currentDecision.choices.forEach {
                $0.enable = true
            }

            currentDecision.incWheelVersion()
        }
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
