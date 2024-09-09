//
//  ChoiceTip.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/9.
//

import SwiftUI
import TipKit

struct ChoiceTip: Tip {
    var image: Image? {
        Image(systemName: "lightbulb")
    }

    var title: Text {
        Text("编辑选项")
    }

    var message: Text? {
        Text("**点击选项**可以编辑选项名和权重\n被选中概率=权重/总权重\n**向左滑动**删除选项")
    }
}
