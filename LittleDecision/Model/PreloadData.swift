//
//  preload.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/8/15.
//

import Defaults
import Foundation
import SwiftData

// swiftlint:disable:next function_body_length
func insertData(ctx: ModelContext) {
    // 从 UserDefaults 中读取是否有数据
    if Defaults[.hasData] == true {
        return
    }

    // 获取用户的语言区域
    let locale = Locale.current
    let languageCode = locale.language.languageCode?.identifier ?? "en"

    // 根据语言代码选择对应的 JSON 文件
    let fileName: String
    switch languageCode {
    case "de":
        fileName = "data.de.json"
    case "ja":
        fileName = "data.jp.json"
    case "ko":
        fileName = "data.kr.json"
    case "zh":
        if locale.region?.identifier == "TW" {
            fileName = "data.tw.json"
        } else {
            fileName = "data.zh.json"
        }
    default:
        fileName = "data.en.json"
    }

    // 读取 JSON 文件
    guard let url = Bundle.main.url(forResource: fileName, withExtension: nil),
          let data = try? Data(contentsOf: url),
          let json = try? JSONDecoder().decode(DecisionData.self, from: data) else {
        print("Failed to load or parse \(fileName)")
        return
    }

    var firstDecisionUUID: UUID?

    // 插入数据
    for decision in json.decisions {
        let newDecision = Decision(title: decision.title, choices: [], saved: true)

        ctx.insert(newDecision)

        if firstDecisionUUID == nil {
            firstDecisionUUID = newDecision.uuid
        }

        for choice in decision.choices {
            let newChoice = Choice(content: choice.content, weight: choice.weight)
            newDecision.choices.append(newChoice)
        }
    }

    do {
        try ctx.save()
    } catch {
        Logging.shared.error("\(error)")
    }

    // 设置 hasData 为 true
    Defaults[.hasData] = true

    //     设置默认的 decisionId
    if let firstDecisionUUID {
        Defaults[.decisionId] = firstDecisionUUID
    }
}

// 用于解码 JSON 的结构
struct DecisionData: Codable {
    let decisions: [DecisionItem]
}

struct DecisionItem: Codable {
    let title: String
    let choices: [ChoiceItem]
}

struct ChoiceItem: Codable {
    let content: String
    let weight: Int
}
