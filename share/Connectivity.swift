//
//  Connectivity.swift
//  Moody Tree
//
//  Created by 王雨晨 on 2023/12/14.
//

import Foundation
import WatchConnectivity

final class Connectivity: NSObject {
    @Published var selectedMood: String = ""
    @Published var moodRecordCount: Int = 0
    static let shared = Connectivity()
    override private init() {
        super.init()
#if !os(watchOS)
        guard WCSession.isSupported() else {
            return
        }
#endif
        WCSession.default.delegate = self
        WCSession.default.activate()
    }
}

extension Connectivity: WCSessionDelegate {
    func session(
        _ session: WCSession,
        didReceiveMessage message: [String : Any] = [:]
    ) {
        guard let mood = message["selectedMood"] as? String else {
            return
        }
        self.selectedMood = mood
        updateMoodRecordCount()
        updateEmotionCounts(selectedMood: self.selectedMood)
    }
    
#if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        WCSession.default.activate()
    }
    func sessionDidDeactivate(_ session: WCSession) {
    }
#endif
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // 实现
        }
    public func send(selectedMood: String) -> String {
        guard WCSession.default.activationState == .activated else {
            return "对话未连接，请稍后重试"
        }
#if os(watchOS)
        guard WCSession.default.isCompanionAppInstalled else {
            return "手机端软件未安装"
        }
#else
        guard WCSession.default.isWatchAppInstalled else {
            return "watch端软件未安装"
        }
#endif
        let selectedMood: [String: String] = [
            "selectedMood" : selectedMood
        ]
        print("11111send:\(selectedMood)")
        WCSession.default.transferUserInfo(selectedMood)
        return "发送成功"
    }
    
    private func updateMoodRecordCount() {
        moodRecordCount += 1
        UserDefaults.standard.setValue(moodRecordCount, forKey: "moodRecordCount")
    }
    
    func updateEmotionCounts(selectedMood: String?) {
        guard let mood = selectedMood else {
            return
        }

        let positiveEmotions = ["棒极了", "冲冲冲", "美滋滋"]
        let negativeEmotions = ["好难过", "无语", "生气", "累死了", "焦虑"]

        if positiveEmotions.contains(mood) {
            incrementMonthlyDataCount(forKey: "positiveEmotionCount")
        } else if negativeEmotions.contains(mood) {
            incrementMonthlyDataCount(forKey: "negativeEmotionCount")
        }
        
        if mood == "棒极了" {
            incrementMonthlyDataCount(forKey: "happyCount")
        }else if mood == "冲冲冲" {
            incrementMonthlyDataCount(forKey: "fightingCount")
        }else if mood == "美滋滋" {
            incrementMonthlyDataCount(forKey: "excitedCount")
        }else if mood == "好难过" {
            incrementMonthlyDataCount(forKey: "sadCount")
        }else if mood == "无语" {
            incrementMonthlyDataCount(forKey: "speechlessCount")
        }else if mood == "生气" {
            incrementMonthlyDataCount(forKey: "angryCount")
        }else if mood == "累死了" {
            incrementMonthlyDataCount(forKey: "tiredCount")
        }else if mood == "焦虑" {
            incrementMonthlyDataCount(forKey: "exhaustedCount")
        }
    }
    
    func incrementMonthlyDataCount(forKey key: String) {
        // 获取当前月份的数据
        var monthlyData = getMonthlyData()

        // 更新对应键的值
        monthlyData[key, default: 0] += 1

        // 保存更新后的数据
        UserDefaults.standard.setValue(monthlyData, forKey: "monthlyDataKey")
    }
    
    func getMonthlyData() -> [String: Int] {
        return UserDefaults.standard.dictionary(forKey: "monthlyDataKey") as? [String: Int] ?? ["totalCount": 0,"negativeEmotionCount": 0, "positiveEmotionCount": 0, "happyCount": 0, "excitedCount": 0, "fightingCount": 0, "sadCount": 0, "speechlessCount": 0, "angryCount": 0, "tiredCount": 0, "exhaustedCount": 0]
    }
}
