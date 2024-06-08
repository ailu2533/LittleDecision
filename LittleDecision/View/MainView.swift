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
                    rotateDiceToEndRandomly(diceNode: node1)
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

    func rotateDiceToEndRandomly(diceNode: SCNNode) {
        // 定义旋转的角度（弧度）
        let rotationX = CGFloat(Float.random(in: 0...2 * .pi))
        let rotationY = CGFloat(Float.random(in: 0...2 * .pi))
        let rotationZ = CGFloat(Float.random(in: 0...2 * .pi))

        // 创建旋转动作
        let rotateAction = SCNAction.rotateBy(x: rotationX, y: rotationY, z: rotationZ, duration: 2.0)
        rotateAction.timingMode = .easeInEaseOut  // 设置动作的时间曲线为先加速后减速

        // 计算完成动作的目标方向
        let finalRotationX = CGFloat.pi / 2 * round(rotationX / (CGFloat.pi / 2))
        let finalRotationY = CGFloat.pi / 2 * round(rotationY / (CGFloat.pi / 2))
        let finalRotationZ = CGFloat.pi / 2 * round(rotationZ / (CGFloat.pi / 2))

        // 计算完成动作的持续时间，考虑旋转动作的持续时间
        let maxRotation = max(abs(finalRotationX - rotationX), abs(finalRotationY - rotationY), abs(finalRotationZ - rotationZ))
        let duration = max(0.1, 1.0 * maxRotation / (2 * CGFloat.pi))  // 持续时间与最大角度变化成比例，考虑旋转动作只用了2秒

        let finalOrientationAction = SCNAction.rotateTo(x: finalRotationX, y: finalRotationY, z: finalRotationZ, duration: 2)
        finalOrientationAction.timingMode = .easeInEaseOut  // 使结束动作也先加速后减速

        // 创建一个动作序列
        let sequence = SCNAction.sequence([rotateAction, finalOrientationAction])

        // 执行动作
        diceNode.runAction(sequence)
    }
}
