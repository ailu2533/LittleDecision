//
//  DeckCardView.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/6.
//

import DeckKit
import Foundation
import Subsonic
import SwiftUI

struct DeckCardView: View {
    @StateObject private var shuffle = DeckShuffleAnimation(animation: .bouncy)

    @StateObject private var deckController: DeckController<CardItem>

    @StateObject private var sound = SubsonicPlayer(sound: "flipcard-91468.mp3")
    @StateObject private var shuffleSound = SubsonicPlayer(sound: "riffle-shuffle-46706.mp3")

    init(items: [CardItem]) {
        _deckController = StateObject(wrappedValue: DeckController(items: items, flipOffset: .init(width: 200, height: -150)))
    }

    // 在 View 外部添加这个辅助函数
    private func calculateSize(for proxy: GeometryProxy) -> CGSize {
        let width = proxy.size.width
        let height = proxy.size.height

        if width / height > 2 / 3 {
            // 如果当前宽高比大于 2:3，以高度为基准
            let calculatedWidth = height * 2 / 3

            deckController.flipOffset = .init(width: 0, height: -height - 100)
            return CGSize(width: calculatedWidth, height: height)
        }

        // 如果当前宽高比小于或等于 2:3，以宽度为基准
        let calculatedHeight = width * 3 / 2
        deckController.flipOffset = .init(width: 0, height: -calculatedHeight - 100)
        return CGSize(width: width, height: calculatedHeight)
    }

    var body: some View {
        VStack(spacing: 80) {
            GeometryReader { proxy in

                let size = calculateSize(for: proxy)

                VStack {
                    DeckView2(
                        shuffleAnimation: shuffle,
                        deckController: deckController,
                        swipeLeftAction: { _ in print("Left") },
                        swipeRightAction: { _ in print("Right") },
                        swipeUpAction: { _ in print("Up") },
                        swipeDownAction: { _ in print("Down") },
                        itemView: { item in
                            CardView(
                                text: item.text,
                                isShuffling: shuffle.isShuffling,
                                size: size)
                                .aspectRatio(0.65, contentMode: .fit)
                        }
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            HStack {
                Button("换一个") {
                    if shuffle.isShuffling {
                        return
                    }

                    if deckController.items.count <= 1 {
                        deckController.items = deckController.allItems
                        shuffleSound.play()
                        shuffle.shuffle($deckController.items)

                    } else {
                        sound.play()
                        deckController.flip()
                    }
                }
                .buttonStyle(.borderedProminent)

                Button("重置") {
                    deckController.items = deckController.allItems
                    shuffleSound.play()
                    shuffle.shuffle($deckController.items)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .maxWidth(.infinity)
        .frame(maxHeight: .infinity)
    }
}
