//
//  SoundPlayer.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/11.
//

import Foundation
import Subsonic

// 创建一个单独的 SoundPlayer 类来管理声音

class SoundPlayer {
    static let shared = SoundPlayer()

    private init() {}

    private let flipcardSound = SubsonicPlayer(sound: "flipcard-91468.mp3")

    var enableSound: Bool {
        // TODO: 从defaults 里面取
        return true
    }

    func playFlipCardSound() {
        if enableSound { flipcardSound.play() }
    }
}
