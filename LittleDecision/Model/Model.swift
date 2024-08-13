//
//  Model.swift
//  LittleDecision
//
//  Created by ailu on 2024/4/3.
//

import SwiftData
import SwiftUI

@Model
class Decision {
    let uuid: UUID
    var title: String

    @Relationship(inverse: \Choice.decision)
    var choices: [Choice]

    // 已经保存
    var saved: Bool = false

    var createDate: Date
    var updateDate: Date

    init(uuid: UUID = UUID(), title: String, choices: [Choice], saved: Bool = false) {
        self.uuid = uuid
        self.title = title
        self.choices = choices
        self.saved = saved
        createDate = .now
        updateDate = .now
    }

    var sortedChoices: [Choice] {
        choices.sorted(by: {
            $0.createDate < $1.createDate
        })
    }

    // 总权重
    var totalWeight: Int {
        return choices.reduce(0) { partialResult, choice in
            partialResult + choice.weight
        }
    }
}

extension Decision: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
        hasher.combine(title)
    }
}

extension Decision: CustomStringConvertible {
    var description: String {
        """
        Decision: \(title)
        Choices: \(choices.map(\.description).joined(separator: "\n"))
        """
    }
}

@Model
class Choice {
    var uuid: UUID = UUID()
    var decision: Decision?
    var title: String
    var weight: Int
//    var sortValue: Double

    // 是否可以被选中
    var enable: Bool = true

    var createDate: Date
    // 选中状态
    var choosed: Bool = false

    init(content: String, weight: Int = 1) {
        title = content
        self.weight = weight
        createDate = .now
    }

    var weight4calc: Int {
        let hideWeight = UserDefaults.standard.bool(forKey: "equalWeight")
        return hideWeight ? 1 : weight
    }
}

extension Choice: CustomStringConvertible {
    var description: String {
        """
        Choice: \(title)
        Weight: \(weight)
        """
    }
}

// swiftlint:disable:next function_body_length
func insertData(ctx: ModelContext) {
    // 从userDefaults中读取是否有数据
    let hasData = UserDefaults.standard.bool(forKey: "hasData")
    if hasData {
        return
    }

    // 设置hasData为true
    UserDefaults.standard.set(true, forKey: "hasData")

    // 创建周末干什么的决策
    let weekendChoice1 = Choice(content: "图书馆认真看书", weight: 1)
    let weekendChoice2 = Choice(content: "打篮球", weight: 1)
    let weekendChoice3 = Choice(content: "去自习室自习", weight: 1)
    let weekendChoice4 = Choice(content: "约TA去逛街、看电影", weight: 1)
    let weekendChoice5 = Choice(content: "宿舍打游戏", weight: 1)
    let weekendChoice6 = Choice(content: "宅着追剧", weight: 1)
    let weekendChoice7 = Choice(content: "睡懒觉", weight: 1)

    let weekendDecision = Decision(title: "周末干点嘛", choices: [
    ], saved: true)

    weekendDecision.choices.append(contentsOf: [
        weekendChoice1,
        weekendChoice2,
        weekendChoice3,
        weekendChoice4,
        weekendChoice5,
        weekendChoice6,
        weekendChoice7,
    ])

    // 创建聚餐吃什么的决策
    let dinnerChoice1 = Choice(content: "火锅", weight: 1)
    let dinnerChoice2 = Choice(content: "自助餐", weight: 1)
    let dinnerChoice3 = Choice(content: "烤鱼", weight: 1)
    let dinnerChoice4 = Choice(content: "新疆菜", weight: 1)
    let dinnerChoice5 = Choice(content: "烧烤", weight: 1)
    let dinnerChoice6 = Choice(content: "东北菜", weight: 1)
    let dinnerChoice7 = Choice(content: "川菜", weight: 1)
    let dinnerChoice8 = Choice(content: "粤菜", weight: 1)
    let dinnerChoice9 = Choice(content: "西餐", weight: 1)
    let dinnerChoice10 = Choice(content: "日料", weight: 1)
    let dinnerChoice11 = Choice(content: "韩餐", weight: 1)
    let dinnerChoice12 = Choice(content: "泰国菜", weight: 1)

    let dinnerDecision = Decision(title: "聚餐去吃什么", choices: [], saved: true)

    dinnerDecision.choices.append(contentsOf: [
        dinnerChoice1,
        dinnerChoice2,
        dinnerChoice3,
        dinnerChoice4,
        dinnerChoice5,
        dinnerChoice6,
        dinnerChoice7,
        dinnerChoice8,
        dinnerChoice9,
        dinnerChoice10,
        dinnerChoice11,
        dinnerChoice12,
    ])

    // 创建约会干什么的决策
    let dateChoice1 = Choice(content: "看个电影", weight: 1)
    let dateChoice2 = Choice(content: "去游乐场玩", weight: 1)
    let dateChoice3 = Choice(content: "一起打台球", weight: 1)
    let dateChoice4 = Choice(content: "小吃街吃一圈", weight: 1)
    let dateChoice5 = Choice(content: "一起去爬山", weight: 1)
    let dateChoice6 = Choice(content: "看个展览", weight: 1)
    let dateChoice7 = Choice(content: "学习做陶艺", weight: 1)

    // 新增的选项
    let dateChoice8 = Choice(content: "去海边散步", weight: 1)
    let dateChoice9 = Choice(content: "一起做饭", weight: 1)
    let dateChoice10 = Choice(content: "去博物馆", weight: 1)
    let dateChoice11 = Choice(content: "去动物园", weight: 1)
    let dateChoice12 = Choice(content: "去植物园", weight: 1)

    let dateDecision = Decision(title: "明天约会去干点啥", choices: [], saved: true)

    dateDecision.choices.append(contentsOf: [
        dateChoice1,
        dateChoice2,
        dateChoice3,
        dateChoice4,
        dateChoice5,
        dateChoice6,
        dateChoice7,
        dateChoice8,
        dateChoice9,
        dateChoice10,
        dateChoice11,
        dateChoice12,
    ])

    // 创建今天中午吃什么的决策
    let lunchChoice1 = Choice(content: "黄焖鸡米饭", weight: 1)
    let lunchChoice2 = Choice(content: "牛肉拉面", weight: 1)
    let lunchChoice3 = Choice(content: "水饺", weight: 1)
    let lunchChoice4 = Choice(content: "烤肉饭", weight: 1)
    let lunchChoice5 = Choice(content: "牛肉汤", weight: 1)
    let lunchChoice6 = Choice(content: "米线", weight: 1)
    let lunchChoice7 = Choice(content: "肯德基", weight: 1)
    let lunchChoice8 = Choice(content: "麻辣香锅", weight: 1)

    let lunchDecision = Decision(title: "今天中午吃什么", choices: [
    ], saved: true)

    lunchDecision.choices.append(contentsOf: [
        lunchChoice1,
        lunchChoice2,
        lunchChoice3,
        lunchChoice4,
        lunchChoice5,
        lunchChoice6,
        lunchChoice7,
        lunchChoice8,
    ])

    // 创建假期去哪个城市玩的决策
    let vacationChoice1 = Choice(content: "北京", weight: 1)
    let vacationChoice2 = Choice(content: "上海", weight: 1)
    let vacationChoice3 = Choice(content: "广州", weight: 1)
    let vacationChoice4 = Choice(content: "深圳", weight: 1)
    let vacationChoice5 = Choice(content: "杭州", weight: 1)
    let vacationChoice6 = Choice(content: "成都", weight: 1)
    let vacationChoice7 = Choice(content: "西安", weight: 1)
    let vacationChoice8 = Choice(content: "重庆", weight: 1)

    let vacationDecision = Decision(title: "假期去哪个城市玩", choices: [
    ], saved: true)

    vacationDecision.choices.append(contentsOf: [
        vacationChoice1,
        vacationChoice2,
        vacationChoice3,
        vacationChoice4,
        vacationChoice5,
        vacationChoice6,
        vacationChoice7,
        vacationChoice8,
    ])

    // 创建真心话大冒险之真心话的决策
    let truthChoice1 = Choice(content: "你有过暗恋吗？", weight: 1)
    let truthChoice2 = Choice(content: "你最害怕的事情是什么？", weight: 1)
    let truthChoice3 = Choice(content: "你会在意对方的过去吗？", weight: 1)
    let truthChoice4 = Choice(content: "你做过最尴尬的事情是什么？", weight: 1)
    let truthChoice5 = Choice(content: "你的初吻是在几岁？", weight: 1)
    let truthChoice6 = Choice(content: "你第一个喜欢的人叫什么名字？", weight: 1)
    let truthChoice7 = Choice(content: "你有没有当过第三者？", weight: 1)
    let truthChoice8 = Choice(content: "你喜欢裸睡吗？", weight: 1)

    let truthDecision = Decision(title: "真心话大冒险之真心话", choices: [
    ], saved: true)

    truthDecision.choices.append(contentsOf: [
        truthChoice1,
        truthChoice2,
        truthChoice3,
        truthChoice4,
        truthChoice5,
        truthChoice6,
        truthChoice7,
        truthChoice8,
    ])

    // 创建真心话大冒险之大冒险的决策

    let dareChoice2 = Choice(content: "公主抱你身边最近的人", weight: 1)
    let dareChoice3 = Choice(content: "做一个最性感的表情", weight: 1)
    let dareChoice4 = Choice(content: "在肯德基点一份麦旋风", weight: 1)
    let dareChoice5 = Choice(content: "和你右边的人接吻10秒", weight: 1)

    // 新增的选项
    let dareChoice6 = Choice(content: "模仿一个你喜欢的电影角色", weight: 1)
    let dareChoice7 = Choice(content: "给在场的每个人一个拥抱", weight: 1)
    let dareChoice8 = Choice(content: "讲一个你最喜欢的笑话", weight: 1)
    let dareChoice9 = Choice(content: "做一个你最喜欢的运动动作", weight: 1)

    let dareDecision = Decision(title: "真心话大冒险之大冒险", choices: [], saved: true)

    dareDecision.choices.append(contentsOf: [
        dareChoice2,
        dareChoice3,
        dareChoice4,
        dareChoice5,
        dareChoice6,
        dareChoice7,
        dareChoice8,
        dareChoice9,
    ])
    ctx.insert(truthDecision)
    ctx.insert(dareDecision)

    ctx.insert(dinnerDecision)
    ctx.insert(dateDecision)
    ctx.insert(lunchDecision)
    ctx.insert(vacationDecision)
    ctx.insert(weekendDecision)

    // 设置hasData为true
    UserDefaults.standard.set(weekendDecision.uuid.uuidString, forKey: "decisionId")
}
