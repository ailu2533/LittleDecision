//
//  DeckModeView.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/6.
//

import DeckKit
import Defaults
import Foundation
import SwiftData
import SwiftUI

struct DeckModeView: View {
    @Default(.decisionId) private var decisionId

    @Environment(\.modelContext)
    private var modelContext

    var items: [CardItem] {
        if let currentDecision {
            return currentDecision.choices.compactMap({ choice in
                CardItem(text: choice.title)
            })
        }
        return []
    }

    var body: some View {
        let _ = Self._printChanges()
        VStack {
            DecisionTitle(currentDecisionTitle: currentDecision?.title)

            DeckCardView(items: items)
                .mainBackground()
                .id(decisionId)
        }
    }

    private var currentDecision: Decision? {
        let predicate = #Predicate<Decision> { $0.uuid == decisionId }
        let descriptor = FetchDescriptor(predicate: predicate)

        do {
            let res = try modelContext.fetch(descriptor).first
            Logging.shared.debug("currentDecision: \(res.debugDescription)  isNil \(res == nil)")
            return res
        } catch {
            Logging.shared.error("currentDecision: \(error)")
            return nil
        }
    }
}
