import Charts
import Defaults
import SpinWheel
import SwiftUI

struct ChartContent: View {
    // MARK: Lifecycle

    init(currentDecision: Decision, radius: CGFloat) {
        self.currentDecision = currentDecision
        Logging.shared.debug("ChartContent init")
        self.radius = radius
    }

    // MARK: Internal

    var currentDecision: Decision
    let radius: CGFloat

    var body: some View {
        SpinWheel(
            rawItems: spinCellItems,
            size: CGSize(width: radius, height: radius),
            configuration: configuration
        )
    }

    // MARK: Private

    @Default(.selectedSkinConfiguration)
    private var selectedSkinConfiguration

    private var configuration: SpinWheelConfiguration {
        SkinManager.shared.getSkinConfiguration(skinKind: selectedSkinConfiguration)
    }

    // equalWeight
    // choice的改变，增加，删除，改变权重
    // decision改变
    private var spinCellItems: [SpinCellItem] {
        return currentDecision.sortedChoices.map { choice in
            SpinCellItem(id: choice.uuid, title: choice.title, weight: CGFloat(choice.weight4calc), enabled: choice.enable)
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
