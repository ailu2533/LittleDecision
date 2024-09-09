//
//  DeckCardView.swift
//  LittleDecision
//
//  Created by Lu Ai on 2024/9/6.
//

import DeckKit
import Foundation
import SwiftUI

struct CardView: View {
    var text: String
    var isShuffling: Bool
    var body: some View {
        let _ = Self._printChanges()
        Text(text)
            .padding()
            .frame(width: 200, height: 300)
            .background {
                Image(.background)
                    .resizable()
                    .scaledToFill()
            }
            .overlay(content: {
                if isShuffling {
                    Image(.cardbackYellow)
                        .resizable()
                        .scaledToFill()
                }
            })

            .clipShape(RoundedRectangle(cornerRadius: 12))
            .font(.title)
            .fontWeight(.semibold)
            .shadow(radius: 1)
    }
}

struct Hobby: DeckItem {
    var text: String
    let id = UUID()

//    var id: String { text }

    init(text: String) {
        self.text = text
    }
}

private let items: [Hobby] = [
    Hobby(text: "你最多同时和几个人恋爱？"),
    Hobby(text: "到目前为止写过多少封情书？"),
    Hobby(text: "你在感情上劈过腿没有？"),
    Hobby(text: "你心里面一直惦记着的名字是？"),
    Hobby(text: "如果有来生，你选择当？"),
    Hobby(text: "你考过的最低分是多少？"),
    Hobby(text: "你考試作弊了嗎？"),
    Hobby(text: "如果你是異性一周，你會怎麼做"),
    Hobby(text: "你最多同时和几个人恋爱？"),
    Hobby(text: "到目前为止写过多少封情书？"),
    Hobby(text: "你在感情上劈过腿没有？"),
    Hobby(text: "你心里面一直惦记着的名字是？"),
    Hobby(text: "如果有来生，你选择当？"),
    Hobby(text: "你考过的最低分是多少？"),
    Hobby(text: "你考試作弊了嗎？"),
    Hobby(text: "如果你是異性一周，你會怎麼做"),
    Hobby(text: "你最多同时和几个人恋爱？"),
    Hobby(text: "到目前为止写过多少封情书？"),
    Hobby(text: "你在感情上劈过腿没有？"),
    Hobby(text: "你心里面一直惦记着的名字是？"),
    Hobby(text: "如果有来生，你选择当？"),
    Hobby(text: "你考过的最低分是多少？"),
    Hobby(text: "你考試作弊了嗎？"),
    Hobby(text: "如果你是異性一周，你會怎麼做"),
    Hobby(text: "你最多同时和几个人恋爱？"),
    Hobby(text: "到目前为止写过多少封情书？"),
    Hobby(text: "你在感情上劈过腿没有？"),
    Hobby(text: "你心里面一直惦记着的名字是？"),
    Hobby(text: "如果有来生，你选择当？"),
    Hobby(text: "你考过的最低分是多少？"),
    Hobby(text: "你考試作弊了嗎？"),
    Hobby(text: "如果你是異性一周，你會怎麼做"),
]

struct DeckCardView: View {
    @StateObject private var shuffle = DeckShuffleAnimation(animation: .snappy)

    @StateObject private var deckController: DeckController<Hobby>

    init(items: [Hobby]) {
        _deckController = StateObject(wrappedValue: DeckController(items: items, flipOffset: .init(width: 200, height: -150)))
    }

    var body: some View {
        VStack(spacing: 80) {
            DeckView2(
                shuffleAnimation: shuffle,
                deckController: deckController,
                swipeLeftAction: { _ in print("Left") },
                swipeRightAction: { _ in print("Right") },
                swipeUpAction: { _ in print("Up") },
                swipeDownAction: { _ in print("Down") },
                itemView: { item in
                    CardView(text: item.text, isShuffling: shuffle.isShuffling)
                        .aspectRatio(0.65, contentMode: .fit)
                }
            )

            HStack {
                Button("换一个") {
                    
                    if shuffle.isShuffling {
                        return
                    }
                    
                    if deckController.items.count <= 1 {
                        deckController.items = deckController.allItems
                        shuffle.shuffle($deckController.items)
                    } else {
                        deckController.flip()
                    }
                }
                .buttonStyle(.borderedProminent)

                Button("重置") {
                    deckController.items = deckController.allItems
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
