//
//  CardItem.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/10.
//

import DeckKit
import Foundation

struct CardItem: DeckItem {
    var text: String
    let id = UUID()

//    var id: String { text }

    init(text: String) {
        self.text = text
    }
}
