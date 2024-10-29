//
//  ToolbarView.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/31.
//

import Defaults
import Foundation
import SwiftUI

struct ToolbarView: ToolbarContent {
    // MARK: Internal

//    @Binding var isSettingsPresented: Bool
//    @Binding var isDecisionListPresented: Bool
//    @Binding var isSkinListPresented: Bool

    @Binding var activeSheet: ActiveSheet?

    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarLeading) {
            Button(action: {
//                isSettingsPresented = true

                activeSheet = .settings

            }, label: {
                Label(
                    title: { Text("设置") },
                    icon: { Image(systemName: "gear")
                    }
                )

            })
        }

        ToolbarItemGroup(placement: .topBarTrailing) {
            Button(action: {
//                isSkinListPresented = true
                activeSheet = .skinList
            }, label: {
                Label(
                    title: { Text("皮肤") },
                    icon: { Image(systemName: "paintpalette")
                    }
                )
            })

            Button(action: {
//                isDecisionListPresented = true
                activeSheet = .decisionList
            }, label: {
                Label(
                    title: { Text("决定列表") },
                    icon: { Image(systemName: "list.bullet")
                    }
                )

            })
        }
    }

    // MARK: Private

    @Default(.decisionDisplayMode) private var decisionDisplayMode
}
