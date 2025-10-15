import Charts
import Defaults
import SpinWheel
import SwiftUI

struct ChartContent: View {
    // MARK: Lifecycle

    init(choiceItems: [ChoiceItem], radius: CGFloat) {
        self.choiceItems = choiceItems
        self.radius = radius
    }

    // MARK: Internal

    var body: some View {
        _ = Self._printChanges()
        SpinWheel(
            rawItems: spinCellItems,
            size: CGSize(width: radius, height: radius),
            configuration: configuration
        )
    }

    // MARK: Private

    private var choiceItems: [ChoiceItem]
    private var radius: CGFloat

    @Default(.selectedSkinConfiguration)
    private var selectedSkinConfiguration

    private var configuration: SpinWheelConfiguration {
        SkinManager.shared.getSkinConfiguration(skinKind: selectedSkinConfiguration)
    }

    private var spinCellItems: [SpinCellItem] {
        choiceItems.map { choice in
            SpinCellItem(
                id: choice.uuid,
                title: choice.content,
                weight: choice.weight,
                enabled: choice.enable
            )
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
