//
//  DecisionBackupDocument.swift
//  LittleDecision
//
//  Created by Codex.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct DecisionBackupDocument: FileDocument {
    static var readableContentTypes: [UTType] {
        [.json]
    }

    static let empty = DecisionBackupDocument(backup: DecisionBackup(decisions: []))

    var backup: DecisionBackup

    init(backup: DecisionBackup) {
        self.backup = backup
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }

        backup = try JSONDecoder().decode(DecisionBackup.self, from: data)
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: try jsonData())
    }

    func jsonData() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

        return try encoder.encode(backup)
    }
}
