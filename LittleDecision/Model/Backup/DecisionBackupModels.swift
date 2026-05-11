//
//  DecisionBackupModels.swift
//  LittleDecision
//
//  Created by Codex.
//

import Foundation
import SwiftData

struct DecisionBackup: Codable {
    static let currentVersion = 1

    let version: Int
    let exportedAt: Date
    let decisions: [BackupDecision]

    init(version: Int = Self.currentVersion, exportedAt: Date = .now, decisions: [BackupDecision]) {
        self.version = version
        self.exportedAt = exportedAt
        self.decisions = decisions
    }

    init(decisions: [Decision], exportedAt: Date = .now) {
        self.init(
            version: Self.currentVersion,
            exportedAt: exportedAt,
            decisions: decisions.map(BackupDecision.init(decision:))
        )
    }

    func normalized() -> DecisionBackup {
        let normalizedDecisions = decisions.map { $0.normalized() }
        return DecisionBackup(
            version: version,
            exportedAt: exportedAt,
            decisions: deduplicateDecisions(normalizedDecisions)
        )
    }
}

struct BackupDecision: Codable, Identifiable {
    var id: UUID { uuid }

    let uuid: UUID
    var title: String
    var saved: Bool
    var displayModel: Int
    var createDate: Date
    var updateDate: Date
    var choices: [BackupChoice]

    init(
        uuid: UUID,
        title: String,
        saved: Bool,
        displayModel: Int,
        createDate: Date,
        updateDate: Date,
        choices: [BackupChoice]
    ) {
        self.uuid = uuid
        self.title = title
        self.saved = saved
        self.displayModel = displayModel
        self.createDate = createDate
        self.updateDate = updateDate
        self.choices = choices
    }

    init(decision: Decision) {
        self.init(
            uuid: decision.uuid,
            title: decision.title,
            saved: decision.saved,
            displayModel: decision.displayModel,
            createDate: decision.createDate,
            updateDate: decision.updateDate,
            choices: decision.sortedChoices.map(BackupChoice.init(choice:))
        )
    }

    func normalized() -> BackupDecision {
        BackupDecision(
            uuid: uuid,
            title: title,
            saved: saved,
            displayModel: displayModel,
            createDate: createDate,
            updateDate: updateDate,
            choices: deduplicateChoices(choices)
        )
    }

    func merged(with other: BackupDecision) -> BackupDecision {
        BackupDecision(
            uuid: other.uuid,
            title: other.title,
            saved: other.saved,
            displayModel: other.displayModel,
            createDate: other.createDate,
            updateDate: other.updateDate,
            choices: deduplicateChoices(choices + other.choices)
        )
    }
}

struct BackupChoice: Codable, Identifiable {
    var id: UUID { uuid }

    let uuid: UUID
    var title: String
    var weight: Int
    var enable: Bool
    var createDate: Date

    init(uuid: UUID, title: String, weight: Int, enable: Bool, createDate: Date) {
        self.uuid = uuid
        self.title = title
        self.weight = weight
        self.enable = enable
        self.createDate = createDate
    }

    init(choice: Choice) {
        self.init(
            uuid: choice.uuid,
            title: choice.title,
            weight: choice.weight,
            enable: choice.enable,
            createDate: choice.createDate
        )
    }

    func merged(with other: BackupChoice) -> BackupChoice {
        other
    }
}

private func deduplicateDecisions(_ decisions: [BackupDecision]) -> [BackupDecision] {
    var lookup: [UUID: BackupDecision] = [:]

    for decision in decisions {
        if let existing = lookup[decision.uuid] {
            lookup[decision.uuid] = existing.merged(with: decision)
        } else {
            lookup[decision.uuid] = decision
        }
    }

    return lookup.values.sorted(by: sortBackupDecision)
}

private func deduplicateChoices(_ choices: [BackupChoice]) -> [BackupChoice] {
    var lookup: [UUID: BackupChoice] = [:]

    for choice in choices {
        if let existing = lookup[choice.uuid] {
            lookup[choice.uuid] = existing.merged(with: choice)
        } else {
            lookup[choice.uuid] = choice
        }
    }

    return lookup.values.sorted(by: sortBackupChoice)
}

private func sortBackupDecision(_ lhs: BackupDecision, _ rhs: BackupDecision) -> Bool {
    if lhs.createDate == rhs.createDate {
        return lhs.uuid.uuidString < rhs.uuid.uuidString
    }

    return lhs.createDate < rhs.createDate
}

private func sortBackupChoice(_ lhs: BackupChoice, _ rhs: BackupChoice) -> Bool {
    if lhs.createDate == rhs.createDate {
        return lhs.uuid.uuidString < rhs.uuid.uuidString
    }

    return lhs.createDate < rhs.createDate
}
