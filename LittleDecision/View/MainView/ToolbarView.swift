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
//    @Binding var isSettingsPresented: Bool
//    @Binding var isDecisionListPresented: Bool
//    @Binding var isSkinListPresented: Bool

    @Binding var activeSheet: ActiveSheet?

    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarLeading) {
            Button {
                activeSheet = .settings
            } label: {
                Label(
                    title: {
                        Text("设置")
                    },
                    icon: {
                        Image(systemName: "gear")
                    }
                )
            }
        }

        ToolbarItemGroup(placement: .topBarTrailing) {
            Button(action: {
                activeSheet = .skinList
            }, label: {
                Label(
                    title: { Text("皮肤") },
                    icon: { Image(systemName: "paintpalette")
                    }
                )
            })

            Button(action: {
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
}
