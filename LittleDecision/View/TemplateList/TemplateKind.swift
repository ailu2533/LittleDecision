//
//  TemplateKind.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/11.
//

import Foundation
import SwiftUI

enum TemplateKind: String, Identifiable, CaseIterable, Codable {
    case hot
    case romance
    case truth
    case dare
    case school
    case life
    case party

    var id: String {
        rawValue
    }

    var text: LocalizedStringKey {
        switch self {
        case .hot:
            return "热门"
        case .romance:
            return "恋爱"
        case .truth:
            return "真心话"
        case .dare:
            return "大冒险"
        case .school:
            return "校园生活"
        case .life:
            return "生活"
        case .party:
            return "聚会"
        }
    }
}
