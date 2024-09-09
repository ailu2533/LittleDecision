//
//  SwiftUIView.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/9.
//

import SwiftUI
import TipKit

struct UseDecisionTip: Tip {
    var title: Text {
        Text("使用提示")
    }

    var message: Text? {
        Text("点击**方框**使用决定\n向左滑动删除决定")
    }

    var image: Image? {
        Image(systemName: "lightbulb")
    }
}
