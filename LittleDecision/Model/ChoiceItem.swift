//
//  ChoiceItem.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/10/29.
//

import Foundation

struct ChoiceItem: Codable {
    // MARK: Lifecycle

    init(uuid: UUID = UUID(), content: String, weight: Int) {
        self.uuid = uuid
        self.content = content
        self.weight = weight
    }

    init(choice: Choice) {
        self.uuid = choice.uuid
        self.weight = choice.weight
        self.content = choice.title
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uuid = try container.decodeIfPresent(UUID.self, forKey: .uuid) ?? UUID()
        self.content = try container.decode(String.self, forKey: .content)
        self.weight = try container.decode(Int.self, forKey: .weight)
    }

    // MARK: Internal

    let uuid: UUID
    let content: String
    let weight: Int
}

extension ChoiceItem: Identifiable {
    var id: UUID {
        uuid
    }
}

extension ChoiceItem: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.uuid == rhs.uuid && lhs.content == rhs.content && lhs.weight == rhs.weight
    }
}
