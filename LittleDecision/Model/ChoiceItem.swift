//
//  ChoiceItem.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/10/29.
//

import Defaults
import Foundation

// MARK: - ChoiceItem

struct ChoiceItem: Codable {
    // MARK: Lifecycle

//    init(uuid: UUID = UUID(), content: String, weight: Int) {
//        self.uuid = uuid
//        self.content = content
//        self.weight = weight
//        enable = true
//    }

    init(choice: Choice) {
        uuid = choice.uuid
        content = choice.title

        if Defaults[.equalWeight] {
            weight = 1
        } else {
            weight = choice.weight
        }

        if Defaults[.noRepeat] {
            enable = choice.enable
        } else {
            enable = true
        }
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try container.decodeIfPresent(UUID.self, forKey: .uuid) ?? UUID()
        content = try container.decode(String.self, forKey: .content)
        weight = try container.decode(Int.self, forKey: .weight)
        enable = true
    }

    // MARK: Internal

    let uuid: UUID
    let content: String
    let weight: Int
    let enable: Bool
}

// MARK: Identifiable

extension ChoiceItem: Identifiable {
    var id: UUID {
        uuid
    }
}

// MARK: Equatable

extension ChoiceItem: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.uuid == rhs.uuid
            && lhs.content == rhs.content
            && lhs.weight == rhs.weight
            && lhs.enable == rhs.enable
    }
}
