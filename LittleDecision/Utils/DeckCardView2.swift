import SwiftUI

struct CardFront: View {
    let text: String
    var rotationDegree: CGFloat = .zero
    let size: CGSize

    var body: some View {
        Text(text)
            .padding()
            .frame(width: size.width, height: size.height)
            .font(customBodyFont)
            .background {
                Image(.background)
                    .resizable()
                    .scaledToFill()
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(radius: 1)

            .rotation3DEffect(
                .degrees(rotationDegree),
                axis: (x: 0.0, y: 1.0, z: 0.01)
            )
    }
}

struct CardBack: View {
    var rotationDegree: CGFloat = .zero
    let size: CGSize

    var enableWiggle: Bool

    var body: some View {
        Image(.cardbackYellow)
            .resizable()
            .scaledToFill()
            .frame(width: size.width, height: size.height)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(radius: 1)
            .rotation3DEffect(
                .degrees(rotationDegree),
                axis: (x: 0.0, y: 1.0, z: 0.01)
            )
            .rotationEffect(.degrees(enableWiggle ? 2.5 : 0))
    }
}

@Observable
class CardViewModel {
    var backDegree: CGFloat = 0
    var frontDegree: CGFloat = -90

    var isScaled = false
    var isFlipped = false
    var xOffset: CGFloat = 0

    var showMask: Bool = false
    var text: String = ""

    var items: [String] = []

    var choices: [String] = []

    var enableWiggle: Bool = false

    @ObservationIgnored
    var isFliping = false

    var tapCount = 0

    func flip() {
        if isFliping {
            return
        }

        isFliping = true

        tapCount += 1
        isFlipped.toggle()

        if isFlipped {
            flipToFront()
        } else {
            flipToBack()
        }
    }

    func restore() {
        if isFlipped {
            let animation = Animation.linear(duration: scaleDurationAndDelay)

            withAnimation(animation) {
                self.isScaled = false
                self.xOffset = .zero

                self.frontDegree = -90
            }

            withAnimation(animation.delay(scaleDurationAndDelay)) {
                backDegree = 0
            } completion: {
                self.items = self.choices.shuffled()
                self.isFlipped = false
            }

            withAnimation(.easeInOut(duration: 0.05).repeatCount(6).delay(2 * scaleDurationAndDelay)) {
                enableWiggle.toggle()
            } completion: {
                self.enableWiggle = false
            }

        } else {
            withAnimation(.easeInOut(duration: 0.05).repeatCount(6)) {
                enableWiggle.toggle()
            } completion: {
                self.enableWiggle = false
            }
        }

        tapCount += 1
    }

    private func flipToFront() {
        let animation = Animation.linear(duration: scaleDurationAndDelay)

        SoundPlayer.shared.playFlipCardSound()

        withAnimation(animation) {
            showMask = true
            isScaled = true
        } completion: {
            if !self.items.isEmpty {
                self.text = self.items.removeFirst()
            } else {
                self.text = String(localized: "没有了，请按\"还原\"按钮")
            }
        }

        withAnimation(animation.delay(scaleDurationAndDelay)) {
            backDegree = 90
        }

        withAnimation(animation.delay(scaleDurationAndDelay * 2)) {
            frontDegree = 0
        } completion: {
            self.isFliping = false
        }
    }

    private func flipToBack() {
        let animation = Animation.linear(duration: durationAndDelay)

        withAnimation(animation) {
            xOffset = kXOffset
        }

        withAnimation(animation.delay(durationAndDelay)) {
            showMask = false
        } completion: {
            self.isScaled = false
            self.backDegree = 0
            self.frontDegree = -90
            self.xOffset = .zero

            self.isFliping = false
        }
    }
}

let durationAndDelay: CGFloat = 0.2
let scaleDurationAndDelay: CGFloat = 0.15
let kXOffset: CGFloat = UIScreen.main.bounds.width
let kScale: CGFloat = 0.85

struct Card: View {
    var cardViewModel: CardViewModel
    let size: CGSize

    var body: some View {
        ZStack {
            CardFront(
                text: cardViewModel.text,
                rotationDegree: cardViewModel.frontDegree,
                size: size
            )
            CardBack(
                rotationDegree: cardViewModel.backDegree,
                size: size,
                enableWiggle: cardViewModel.enableWiggle
            )
        }
        .scaleEffect(cardViewModel.isScaled ? 1 : kScale)
        .offset(x: cardViewModel.xOffset)
        .onTapGesture {
            cardViewModel.flip()
        }
        .sensoryFeedback(.impact, trigger: cardViewModel.tapCount)
    }
}

struct DeckView: View {
    @State private var cardViewModel = CardViewModel()

    let choices: [String]

    var body: some View {
        VStack {
            GeometryReader { proxy in
                let maxWidth = min(proxy.size.width, proxy.size.height / 1.5) * 0.8
                let size = CGSize(width: maxWidth, height: maxWidth * 1.5)

                ZStack {
                    CardBack(rotationDegree: 0, size: size, enableWiggle: false)
                        .scaleEffect(kScale)
                        .disabled(true)
                        .overlay {
                            Color.black.opacity(0.2)
                                .opacity(cardViewModel.showMask ? 1 : 0)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .scaleEffect(kScale)
                        }
                    Color.almostClear.ignoresSafeArea()
                        .opacity(cardViewModel.showMask ? 1 : 0)
                        .onTapGesture {
                            cardViewModel.flip()
                        }
                    Card(cardViewModel: cardViewModel, size: size)
                }
            }

            Spacer()

            HStack {
                Spacer()
                Button(action: {
                    cardViewModel.restore()
                }, label: {
                    Label("还原", systemImage: "arrow.clockwise")
                })
                .buttonStyle(RestoreButtonStyle())
                .padding()
            }
        }
        .padding(.horizontal, 12)
        .onAppear {
            cardViewModel.choices = choices
            cardViewModel.items = choices
        }
    }
}

#Preview {
    DeckView(choices: [])
}
