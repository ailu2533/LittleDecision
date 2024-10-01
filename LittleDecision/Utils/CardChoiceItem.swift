//
//  CardChoiceItem.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/10/1.
//

import Foundation

struct CardChoiceItem: Equatable {
    let id = UUID()
    let content: String
    let weight: Int

    init(content: String, weight: Int) {
        self.content = content
        self.weight = weight
    }
}
