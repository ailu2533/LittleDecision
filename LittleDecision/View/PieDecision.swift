//
//  PieChartView.swift
//  Widget
//
//  Created by ailu on 2024/3/21.
//

import Charts
import Combine
import SwiftData
import SwiftUI

func genSpeedPoint(h: Double, d: Double) -> [(Double, Double)] {
    let a = h / (d * d)

    var res: [(Double, Double)] = []

    var lastY = 0.0

    for i in stride(from: 0, through: d, by: 0.2) {
        let x = Double(i)
        let y = -a * (x - d) * (x - d) + h
        res.append((x, y - lastY))
        lastY = y
    }

    return res
}

struct PieChartView: View {
    @AppStorage("decisionId") var decisionId: String = UUID().uuidString

    @State private var didVersion = 0

    @Environment(\.modelContext) private var modelContext

    private var currentDecision: Decision {
        let did = UUID(uuidString: decisionId)!

        let p = #Predicate<Decision> {
            $0.uuid == did
        }

        let descriptor = FetchDescriptor(predicate: p)

        do {
            let decisions = try modelContext.fetch(descriptor)

            if let d = decisions.first {
                return d
            }

        } catch {
            print(error.localizedDescription)
        }

        return .init(title: "请选择决定", choices: [])
    }

    @State private var selection: Choice?

    @State private var selectedCount: Double?

    @State private var randomNumber: Double = 0.0

    @State private var rotateAngle: Double = 0.0

    enum Tag {
        case start, middle, end
    }

    struct Msg {
        var tag: Tag
        var angle: Double

        init(tag: Tag, angle: Double) {
            self.tag = tag
            self.angle = angle
        }
    }

    let subject = PassthroughSubject<Msg, Never>()

    fileprivate func start() {
        let res = genSpeedPoint(h: 2000, d: 4)

        for p in res.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + res[p].0) {
                var tag = Tag.middle
                if p == 0 {
                    tag = .start
                } else if p == res.count - 1 {
                    tag = .end
                }

                subject.send(.init(tag: tag, angle: res[p].1))
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                Text(currentDecision.title)
                    .font(.title)
                Chart(currentDecision.sortedChoices) {
                    product in

                    SectorMark(angle: .value(Text(verbatim: product.title), Double(product.weight)),
                               innerRadius: .ratio(0.45),
                               outerRadius: product.uuid == selection?.uuid ? 165 : 150,
                               angularInset: 1)

                        .cornerRadius(12)
                        .annotation(position: .overlay, alignment: .center) {
                            Text(product.title)
                        }

                        .foregroundStyle(by: .value(Text(verbatim: product.title), product.title))
                        .opacity(product.choosed ? 0.1 : 1)

                }.chartAngleSelection(value: $selectedCount)
                    .chartOverlay { chartProxy in

                        GeometryReader { geometry in

                            let frame = geometry[chartProxy.plotFrame!]

                            PointerShape()

                                .fill(.blue.opacity(0.8))
                                .rotationEffect(.degrees(rotateAngle))
                                .frame(width: 150, height: 150)
                                .position(x: frame.midX, y: frame.midY)
                                .overlay(alignment: .center) {
                                    Text("开始")
                                        .foregroundStyle(.black)
                                        .position(x: frame.midX, y: frame.midY)
                                }.onTapGesture {
                                    start()
                                }
                        }
                    }.chartLegend(.hidden)

                HStack {
                    Button(action: {
                        currentDecision.reset()
                        rotateAngle = 0
//                        selectedCount = 0
//                        selectedCount = nil

                    }, label: {
                        Text("还原转盘")
                    }).buttonStyle(BorderedProminentButtonStyle())

                    Button(action: {}, label: {
                        Text("编辑")
                    }).buttonStyle(BorderedProminentButtonStyle())
                }

            }.onChange(of: selectedCount, { _, newValue in
                if let newValue {
                    print(newValue)
                    getSelected(value: newValue)
                }
            }).onReceive(subject, perform: { msg in

                withAnimation {
                    rotateAngle = rotateAngle + msg.angle

                    var rnd = rotateAngle
                    while rnd >= 360 {
                        rnd -= 360
                    }
                    let frac = rnd / 360

                    selectedCount = currentDecision.totalWeight * frac
                }

                if msg.tag == .end {
                    while rotateAngle >= 360 {
                        rotateAngle -= 360
                    }
                }

            })
            .toolbar {
                ToolbarItem {
                    NavigationLink {
                        DecisionListView(didVersion: $didVersion)
                    } label: {
                        Image(systemName: "list.bullet")
                    }
                }
            }

            .padding()
        }
    }

    private func getSelected(value: Double) {
        var cumulativeTotal = 0.0

        selection = currentDecision.sortedChoices.first {
            product in
            cumulativeTotal += Double(product.weight)
            if value <= cumulativeTotal {
                return true
            }
            return false
        }

        // TODO: 最后一个时
//        selection?.choosed = true
//        print("选中的选项 \(selection?.title)")
    }
}

#Preview {
    PieChartView()
}
