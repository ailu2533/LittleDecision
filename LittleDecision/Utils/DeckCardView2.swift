import Defaults
import LemonViews
import SwiftUI

let durationAndDelay: CGFloat = 0.2
let scaleDurationAndDelay: CGFloat = 0.15
let kXOffset: CGFloat = UIScreen.main.bounds.width
let kScale: CGFloat = 0.85

struct DeckView: View {
    @State private var cardViewModel: CardViewModel = CardViewModel(items: [], noRepeat: false)

    let choices: [ChoiceItem]
    let noRepeat: Bool

    init(choices: [ChoiceItem], noRepeat: Bool) {
        self.choices = choices
        self.noRepeat = noRepeat

        Logging.shared.debug("deckview init \(choices.count)")
    }

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
                    Card(cardViewModel: cardViewModel, size: size)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            Spacer()

//            #if DEBUG
//
//                Text("deckStatus \(cardViewModel.deckStatus) isFilped \(cardViewModel.isFlipped)")
//            Text("number of card \(cardViewModel.items.count)")
//            #endif
            
            HStack {
                Spacer()
                Button(action: {
                    cardViewModel.restore()
                }, label: {
                    Label("还原", systemImage: "arrow.clockwise")
                })
                .buttonStyle(FloatingButtonStyle())
                .padding()
            }
        }
        .padding(.horizontal, 12)
        .onAppear {
            cardViewModel = CardViewModel(items: choices, noRepeat: noRepeat)
        }
        .onChange(of: choices) { _, newValue in
            cardViewModel = CardViewModel(items: newValue, noRepeat: noRepeat)
        }
        .onChange(of: noRepeat) { _, newValue in
            cardViewModel = CardViewModel(items: choices, noRepeat: newValue)
        }
    }
}

#Preview {
    DeckView(choices: [], noRepeat: true)
}
