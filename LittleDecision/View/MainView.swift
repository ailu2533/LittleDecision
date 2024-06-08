//
//  MainView.swift
//  LittleDecision
//
//  Created by ailu on 2024/4/10.
//

import SceneKit
import SwiftData
import SwiftUI

struct MainView: View {
    @AppStorage("decisionId") var decisionId: String = UUID().uuidString

    @State private var didVersion = 0

    @Environment(\.modelContext) private var modelContext

    @Environment(DecisionViewModel.self) private var vm

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

    var body: some View {
        TabView {
            FirstView()
                .tabItem {
                    Label("转盘", systemImage: "chart.pie")
                }

            ExtractedView()
            CarouselSettingsView()
                .tabItem {
                    Label("我的", systemImage: "house.circle.fill")
                }
        }
    }
}

#Preview {
    MainView()
}

struct ExtractedView: View {
    let node1 = createDiceNode()
    let node2 = createDiceNode()
    let node3 = createDiceNode()

    var body: some View {
        VStack {
            CubicView(diceNode: node1)
//            CubicView(diceNode: node2)
//            CubicView(diceNode: node3)

            HStack {
                Button(action: {
                    rotateDiceToRandomFace(diceNode: node1)
//                    node2.setFaceUp(face: [1, 2, 3, 4, 5, 6].randomElement() ?? 1)
//                    node3.setFaceUp(face: [1, 2, 3, 4, 5, 6].randomElement() ?? 1)
                }, label: {
                    Text("Button")
                })
            }
        }

        .tabItem {
            Label("随机数", systemImage: "42.circle.fill")
        }
    }


    func rotateDiceToRandomFace(diceNode: SCNNode) {
        // 随机选择一个面，每个面对应一个旋转角度
        let faces = [
            (x: 0, y: 0, z: 0), // 面1
            (x: CGFloat.pi / 2, y: 0, z: 0), // 面2
            (x: -CGFloat.pi / 2, y: 0, z: 0), // 面3
            (x: CGFloat.pi, y: 0, z: 0), // 面4
            (x: 0, y: CGFloat.pi / 2, z: 0), // 面5
            (x: 0, y: -CGFloat.pi / 2, z: 0) // 面6
        ]
        
        let randomFace = faces.randomElement()!
        let additionalRotations = CGFloat.pi * 2 * 2 // 随机额外旋转2到4圈

        // 创建旋转动作到随机面，包括额外的旋转
        let rotateToFaceAction = SCNAction.rotateTo(x: randomFace.x + additionalRotations,
                                                    y: randomFace.y + additionalRotations,
                                                    z: CGFloat(randomFace.z) + additionalRotations,
                                                    duration: 2.0)
        rotateToFaceAction.timingMode = .linear

        // 执行动作
        diceNode.runAction(rotateToFaceAction)
    }
}
