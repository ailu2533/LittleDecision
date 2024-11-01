import Defaults
import LemonViews
import SwiftUI

let kDurationAndDelay: CGFloat = 0.1

// MARK: - DeckView

struct DeckView: View {
    var globalViewModel: GlobalViewModel
    var size: CGSize

    var cardSize: CGSize {
        let maxWidth = min(size.width, size.height / 1.5) * 0.8
        return CGSize(width: maxWidth, height: maxWidth * 1.5)
    }

    var body: some View {
        Card(size: cardSize, globalViewModel: globalViewModel)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
