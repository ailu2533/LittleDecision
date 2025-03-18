//
//  SpinWheel.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/11/15.
//

import Defaults
import SwiftUI

// MARK: GlobalViewModel + SpinWheel

extension GlobalViewModel {
    // MARK: startSpinning

    func startSpinning() {
        guard status == .none else { return }

        setSelectedChoice(nil)

        if let (choice, angle) = LotteryViewModel.select(from: items, noRepeat: Defaults[.noRepeat]) {
            let extraRotation = Defaults[.rotationTime] * 360.0
            let targetAngle = (270 - angle + 360 - spinWheelRotateAngle.truncatingRemainder(dividingBy: 360)) + extraRotation

            status = .isRunning
            
            SoundPlayer.shared.playSpinWheelSound()

            withAnimation(.easeInOut(duration: Defaults[.rotationTime])) {
                spinWheelRotateAngle += targetAngle

            } completion: { [weak self] in
                guard let self else { return }
                setSelectedChoice(choice)
                
                SoundPlayer.shared.stopSpinWheelSound()
                status = .none
            }
        } else {
            restoreSpinWheel()
        }
    }

    // MARK: restoreSpinWheel

    func restoreSpinWheel() {
        guard status == .none else { return }

        status = .isRestoring

        selectedDecision?.unwrappedChoices.forEach { $0.enable = true }

        try? modelContext.save()

        selectedChoice = nil
        refreshItems()

        withAnimation {
            spinWheelRotateAngle -= spinWheelRotateAngle.truncatingRemainder(dividingBy: 360)
        } completion: { [weak self] in
            guard let self else { return }
            status = .none
            spinWheelRotateAngle = 0
        }
    }
}
