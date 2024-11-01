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

    init(uuid: UUID = UUID(), content: String, weight: Int) {
        self.uuid = uuid
        self.content = content
        self.weight = weight
        self.enable = true
    }

    init(choice: Choice) {
        self.uuid = choice.uuid
        self.content = choice.title

        if Defaults[.equalWeight] {
            self.weight = 1
        } else {
            self.weight = choice.weight
        }

        if Defaults[.noRepeat] {
            self.enable = choice.enable
        } else {
            self.enable = true
        }
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uuid = try container.decodeIfPresent(UUID.self, forKey: .uuid) ?? UUID()
        self.content = try container.decode(String.self, forKey: .content)
        self.weight = try container.decode(Int.self, forKey: .weight)
        self.enable = true
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
