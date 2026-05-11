//
//  DecisionBackupStore.swift
//  LittleDecision
//
//  Created by Codex.
//

import Foundation
import SwiftData

enum DecisionBackupStore {
    private static let backupFileName = "LittleDecision-Backup.json"

    static func makeExportDocument(from context: ModelContext) throws -> DecisionBackupDocument {
        let decisions = try fetchDecisions(from: context)
        let backup = DecisionBackup(decisions: decisions).normalized()
        return DecisionBackupDocument(backup: backup)
    }

    static func writeExportDocumentToDocuments(_ document: DecisionBackupDocument) throws -> URL {
        let url = documentsDirectory().appendingPathComponent(backupFileName)
        try document.jsonData().write(to: url, options: .atomic)
        return url
    }

    static func importBackup(from url: URL, into context: ModelContext) throws {
        let data = try readData(from: url)
        let backup = try JSONDecoder().decode(DecisionBackup.self, from: data).normalized()

        try merge(backup: backup, into: context)
        try context.save()
    }
}

extension DecisionBackupStore {
    private static func fetchDecisions(from context: ModelContext) throws -> [Decision] {
        let descriptor = FetchDescriptor<Decision>(
            sortBy: [
                SortDescriptor(\Decision.createDate, order: .forward),
                SortDescriptor(\Decision.uuid, order: .forward),
            ]
        )

        return try context.fetch(descriptor)
    }

    private static func merge(backup: DecisionBackup, into context: ModelContext) throws {
        var decisionLookup: [UUID: Decision] = [:]
        for decision in try fetchDecisions(from: context) where decisionLookup[decision.uuid] == nil {
            decisionLookup[decision.uuid] = decision
        }

        for backupDecision in backup.decisions {
            if let decision = decisionLookup[backupDecision.uuid] {
                merge(backupDecision: backupDecision, into: decision, in: context)
            } else {
                let decision = Decision(
                    uuid: backupDecision.uuid,
                    title: backupDecision.title,
                    choices: [],
                    saved: backupDecision.saved,
                    displayModel: backupDecision.displayModel,
                    createDate: backupDecision.createDate,
                    updateDate: backupDecision.updateDate
                )
                context.insert(decision)
                decisionLookup[decision.uuid] = decision

                let choices = backupDecision.choices.map { backupChoice in
                    let choice = Choice(
                        uuid: backupChoice.uuid,
                        content: backupChoice.title,
                        weight: backupChoice.weight,
                        enable: backupChoice.enable,
                        createDate: backupChoice.createDate
                    )
                    choice.decision = decision
                    context.insert(choice)
                    return choice
                }

                decision.choices = choices.sorted(by: sortChoice)
            }
        }
    }

    private static func merge(backupDecision: BackupDecision, into decision: Decision, in context: ModelContext) {
        decision.title = backupDecision.title
        decision.saved = backupDecision.saved
        decision.displayModel = backupDecision.displayModel
        decision.createDate = backupDecision.createDate
        decision.updateDate = backupDecision.updateDate

        var choiceLookup: [UUID: Choice] = [:]
        for choice in decision.unwrappedChoices where choiceLookup[choice.uuid] == nil {
            choiceLookup[choice.uuid] = choice
        }

        for backupChoice in backupDecision.choices {
            if let choice = choiceLookup[backupChoice.uuid] {
                choice.title = backupChoice.title
                choice.weight = backupChoice.weight
                choice.enable = backupChoice.enable
                choice.createDate = backupChoice.createDate
                choice.decision = decision
            } else {
                let choice = Choice(
                    uuid: backupChoice.uuid,
                    content: backupChoice.title,
                    weight: backupChoice.weight,
                    enable: backupChoice.enable,
                    createDate: backupChoice.createDate
                )
                choice.decision = decision
                context.insert(choice)
                choiceLookup[choice.uuid] = choice
            }
        }

        let mergedChoices = choiceLookup.values.sorted(by: sortChoice)
        mergedChoices.forEach { $0.decision = decision }
        decision.choices = mergedChoices
    }

    private static func readData(from url: URL) throws -> Data {
        let didStartAccessing = url.startAccessingSecurityScopedResource()
        defer {
            if didStartAccessing {
                url.stopAccessingSecurityScopedResource()
            }
        }

        return try Data(contentsOf: url)
    }

    private static func documentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private static func sortChoice(_ lhs: Choice, _ rhs: Choice) -> Bool {
        if lhs.createDate == rhs.createDate {
            return lhs.uuid.uuidString < rhs.uuid.uuidString
        }

        return lhs.createDate < rhs.createDate
    }
}
