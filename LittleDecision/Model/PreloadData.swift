//
//  preload.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/15.
//

import Defaults
import Foundation
import SwiftData

func insertData(ctx: ModelContext) {
    guard !Defaults[.hasData] else { return }

    let fileName = getLocalizedFileName()

    do {
        let json = try loadJSONFile(named: fileName)
        try insertDecisionsFromJSON(json, into: ctx)
        try ctx.save()
        updateDefaults(with: ctx)
    } catch {
        handleError(error, for: fileName)
    }
}

private func getLocalizedFileName() -> String {
    let locale = Locale.current
    let languageCode = locale.language.languageCode?.identifier ?? "en"

    switch languageCode {
    case "de": return "data.de.json"
    case "ja": return "data.jp.json"
    case "ko": return "data.kr.json"
    case "zh": return locale.region?.identifier == "TW" ? "data.tw.json" : "data.zh.json"
    default: return "data.en.json"
    }
}

private func loadJSONFile(named fileName: String) throws -> DecisionData {
    guard let url = Bundle.main.url(forResource: fileName, withExtension: nil) else {
        throw NSError(domain: "FileNotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "无法找到文件: \(fileName)"])
    }

    let data = try Data(contentsOf: url)
    return try JSONDecoder().decode(DecisionData.self, from: data)
}

private func insertDecisionsFromJSON(_ json: DecisionData, into ctx: ModelContext) throws {
    var firstDecisionUUID: UUID?

    for decision in json.decisions {
        let newDecision = Decision(title: decision.title, choices: [], saved: true)
        ctx.insert(newDecision)

        if firstDecisionUUID == nil {
            firstDecisionUUID = newDecision.uuid
        }

        newDecision.choices = decision.choices.map { Choice(content: $0.content, weight: $0.weight) }
    }

    if let firstDecisionUUID {
        Defaults[.decisionID] = firstDecisionUUID
    }
}

private func updateDefaults(with ctx: ModelContext) {
    Defaults[.hasData] = true
}

private func handleError(_ error: Error, for fileName: String) {
    if let nsError = error as NSError? {
        switch nsError.code {
        case NSFileReadUnknownError:
            Logging.shared.error("读取文件时发生未知错误: \(nsError.localizedDescription)")
        case NSFileReadNoPermissionError:
            Logging.shared.error("没有权限读取文件: \(nsError.localizedDescription)")
        case NSFileNoSuchFileError:
            Logging.shared.error("文件不存在: \(nsError.localizedDescription)")
        default:
            handleDecodingError(error)
        }
    } else {
        Logging.shared.error("发生未知错误: \(error.localizedDescription)")
    }
}

private func handleDecodingError(_ error: Error) {
    if let decodingError = error as? DecodingError {
        switch decodingError {
        case let .dataCorrupted(context):
            Logging.shared.error("数据损坏: \(context.debugDescription)")
        case let .keyNotFound(key, context):
            Logging.shared.error("未找到键 '\(key.stringValue)': \(context.debugDescription)")
        case let .typeMismatch(type, context):
            Logging.shared.error("类型不匹配, 期望 \(type): \(context.debugDescription)")
        case let .valueNotFound(type, context):
            Logging.shared.error("未找到值, 期望 \(type): \(context.debugDescription)")
        @unknown default:
            Logging.shared.error("解码时发生未知错误: \(decodingError.localizedDescription)")
        }
    }
}

// 用于解码 JSON 的结构
struct DecisionData: Codable {
    let decisions: [DecisionItem]
}

struct DecisionItem: Codable, Identifiable {
    // MARK: Lifecycle

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        title = try container.decode(String.self, forKey: .title)
        choices = try container.decode([ChoiceItem].self, forKey: .choices)

        // 如果 tags 不存在或解码失败，则使用默认值
        tags = try container.decodeIfPresent([TemplateKind].self, forKey: .tags) ?? []
    }

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case title
        case tags
        case choices
    }

    var id: UUID = UUID()

    let title: String
    let tags: [TemplateKind]
    let choices: [ChoiceItem]
}

struct ChoiceItem: Codable {
    let content: String
    let weight: Int
}
