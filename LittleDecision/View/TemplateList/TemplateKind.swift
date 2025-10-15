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
            "热门"
        case .romance:
            "恋爱"
        case .truth:
            "真心话"
        case .dare:
            "大冒险"
        case .school:
            "校园生活"
        case .life:
            "生活"
        case .party:
            "聚会"
        }
    }
}
