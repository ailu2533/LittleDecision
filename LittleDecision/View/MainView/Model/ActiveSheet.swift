//
//  ActiveSheet.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/10/29.
//

import SwiftUI

enum ActiveSheet: Identifiable, View {
    case decisionList, settings, skinList

    // MARK: Internal

    var id: Self { self }

    var body: some View {
        switch self {
        case .decisionList:
            DecisionListView()
        case .settings:
            SettingsView()
        case .skinList:
            SkinListView()
        }
    }
}
