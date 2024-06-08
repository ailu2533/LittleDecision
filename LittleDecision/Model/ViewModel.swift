//
//  ViewModel.swift
//  LittleDecision
//
//  Created by ailu on 2024/6/8.
//

import Foundation
import SwiftData

@Observable
class ViewModel {
    private let ctx: ModelContext

    init(ctx: ModelContext) {
        self.ctx = ctx
    }

    // 查询所有 decision

    func fetchAllDecisions() -> [Decision] {
        let descriptor = FetchDescriptor<Decision>(sortBy: [SortDescriptor<Decision>(\Decision.createDate, order: .reverse)])

        do {
            let res = try ctx.fetch(descriptor)
            return res
        } catch {
            print(error.localizedDescription)
        }

        return []
    }

    // 根据 uuid 查询 decision
    func fetchDecisionBy(uuid: UUID) -> Decision? {
        let desciptor = FetchDescriptor<Decision>(predicate: #Predicate { decision in
            decision.uuid == uuid
        })

        do {
            return try ctx.fetch(desciptor).first
        } catch {
            Logging.shared.error("fetchDecisionBy uuid: \(uuid)")
            return nil
        }
    }
}
