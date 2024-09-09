//
//  DecisionView.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/9.
//

import SwiftUI

struct DecisionView: View {
    var currentDecision: Decision

    var body: some View {
        switch currentDecision.displayModeEnum {
        case .wheel:
            FirstView()
        case .stackedCards:
            DeckModeView()
        }
    }
}
