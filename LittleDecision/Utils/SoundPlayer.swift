//
//  SoundPlayer.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/11.
//

import Defaults
import Foundation
@preconcurrency import Subsonic

// 创建一个单独的 SoundPlayer 类来管理声音

final class SoundPlayer: Sendable {
    // MARK: Lifecycle

    private init() {}

    // MARK: Internal

    static let shared = SoundPlayer()

    var enableSound: Bool {
        Defaults[.enableSound]
    }

    func playFlipCardSound() {
        if enableSound { flipcardSound.play() }
    }

    func stopFilpCardSound() {
        if flipcardSound.isPlaying {
//            flipcardSound.stop()
        }
    }

    func playSpinWheelSound() {
        if enableSound {
            spinWheelSound.play()
        }
    }

    func stopSpinWheelSound() {
        if spinWheelSound.isPlaying {
            spinWheelSound.stop()
        }
    }

    // MARK: Private

    private let flipcardSound = SubsonicPlayer(sound: "flipcard-91468.mp3")
    private let spinWheelSound = SubsonicPlayer(sound: "8bit-canon-giulio-fazio-main-version-30900-02-48.mp3")
}
