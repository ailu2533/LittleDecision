//
//  CubicView.swift
//  LittleDecision
//
//  Created by ailu on 2024/6/8.
//

import SceneKit
import SwiftUI

func createDiceNode() -> SCNNode {
    // 创建立方体骰子
    let diceGeometry = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0.1)
    let material1 = SCNMaterial()
    material1.diffuse.contents = UIImage(named: "dice1") // 确保有相应的纹理图像

    let material2 = SCNMaterial()
    material2.diffuse.contents = UIImage(named: "dice2") //

    let material3 = SCNMaterial()
    material3.diffuse.contents = UIImage(named: "dice3") //

    let material4 = SCNMaterial()
    material4.diffuse.contents = UIImage(named: "dice4") //

    let material5 = SCNMaterial()
    material5.diffuse.contents = UIImage(named: "dice5") //

    let material6 = SCNMaterial()
    material6.diffuse.contents = UIImage(named: "dice6") //

    diceGeometry.materials = [material1, material2, material3, material4, material5, material6]

    // 创建节点并添加到场景
    let diceNode = SCNNode(geometry: diceGeometry)

    diceNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil) // 使用动态物理类型
    diceNode.physicsBody?.restitution = 0.5 // 弹性
    diceNode.physicsBody?.friction = 0.5 // 摩擦力

    return diceNode
}

struct CubicView: View {
    let diceNode: SCNNode

    init(diceNode: SCNNode) {
        self.diceNode = diceNode
    }

    var body: some View {
        GeometryReader { geometry in
            SceneKitView(scene: createDiceScene(diceNode: diceNode), size: geometry.size)
                .edgesIgnoringSafeArea(.all)
        }
    }

    func createScene() -> SCNScene {
        let scene = SCNScene()
        let colors: [UIColor] = [.red, .white, .blue, .orange, .yellow]
        let squareSize: CGFloat = 1.0
        let chamferRadius: CGFloat = 0.1
        for i in -1 ... 1 {
            for j in -1 ... 1 {
                for k in -1 ... 1 {
                    let box = SCNBox(width: squareSize, height: squareSize, length: squareSize, chamferRadius: chamferRadius)
                    let material = SCNMaterial()
                    material.diffuse.contents = colors.randomElement()
                    material.specular.contents = UIColor.white
                    box.materials = [material]
                    let node = SCNNode(geometry: box)
                    node.position = SCNVector3(Float(i), Float(j), Float(k))
                    scene.rootNode.addChildNode(node)
                }
            }
        }
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
        scene.rootNode.addChildNode(cameraNode)

        scene.physicsWorld.gravity = SCNVector3(x: 0, y: -9.8, z: 0) // 标准重力

        return scene
    }

    func createDiceScene(diceNode: SCNNode) -> SCNScene {
        // 创建场景
        let scene = SCNScene()

        scene.rootNode.addChildNode(diceNode)

        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
//        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)

        cameraNode.position = SCNVector3(x: 0, y: 0, z: 6) // 调整摄像机位置
        cameraNode.look(at: diceNode.position) // 摄像机始终指向骰子

        



        diceNode.position = SCNVector3(0, 0, 0)
        scene.rootNode.addChildNode(cameraNode)
        
        return scene
    }

    func createFloorNode() -> SCNNode {
        // 创建地面几何体
        let floor = SCNFloor()
        floor.reflectivity = 0.0 // 不反射光

        // 创建地面节点
        let floorNode = SCNNode(geometry: floor)
        floorNode.position = SCNVector3(x: 0, y: -0.5, z: 0) // 地面位置稍微低于骰子初始位置
        floorNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil) // 设置为静态物理体
        floorNode.physicsBody?.friction = 0.8 // 设置摩擦力
        floorNode.physicsBody?.restitution = 0.1 // 设置弹性

        return floorNode
    }
}

struct SceneKitView: UIViewRepresentable {
    let scene: SCNScene
    let size: CGSize
    func makeUIView(context: Context) -> SCNView {
        let view = SCNView(frame: CGRect(origin: .zero, size: size), options: nil)
        view.scene = scene
        view.autoenablesDefaultLighting = true
        view.allowsCameraControl = true
        view.backgroundColor = UIColor.white
        return view
    }

    func updateUIView(_ uiView: SCNView, context: Context) {}
}

extension SCNNode {
    func setFaceUp(face: Int) {
        let rotation: SCNVector4
        switch face {
        case 1:
            rotation = SCNVector4(0, 0, 1, 0) // No rotation
        case 2:
            rotation = SCNVector4(0, 1, 0, Float.pi / 2)
        case 3:
            rotation = SCNVector4(1, 0, 0, -Float.pi / 2)
        case 4:
            rotation = SCNVector4(1, 0, 0, Float.pi / 2)
        case 5:
            rotation = SCNVector4(0, 1, 0, -Float.pi / 2)
        case 6:
            rotation = SCNVector4(0, 0, 1, Float.pi)
        default:
            rotation = SCNVector4(0, 0, 0, 0) // Default case, no rotation
        }
        self.rotation = rotation
    }

    func throwDice() {
        let randomX = Float.random(in: -5 ... 5)
        let randomY = Float.random(in: -5 ... 5)
        let randomZ = Float.random(in: -5 ... 5)

        let force = SCNVector3(x: randomX, y: randomY, z: randomZ)
        let position = SCNVector3(x: 0.05, y: 0.05, z: 0.05) // 力的应用点，稍微偏离中心以产生旋转

        physicsBody?.applyForce(force, at: position, asImpulse: true)
    }
}
