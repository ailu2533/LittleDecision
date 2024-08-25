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

    var body: some View {
        Chart(currentDecision.sortedChoices) { choice in

            let title = Text(verbatim: choice.title).foregroundStyle(choice.enable ? .primary : Color.white)
                .font(.system(size: fontSize))

            SectorMark(angle: .value(Text(verbatim: choice.title), Double(choice.weight4calc)), angularInset: 1)
                .cornerRadius(8)
                .foregroundStyle(by: .value(title, choice.uuid.uuidString))
        }
        .chartLegend(.hidden) // 隐藏图例
        .chartForegroundStyleScale(domain: .automatic, range: Self.chartColors)
        .chartOverlay(alignment: .center, content: { proxy in
            ChartOverlayView(proxy: proxy, currentDecision: currentDecision, selection: selection)
        })
    }
}
