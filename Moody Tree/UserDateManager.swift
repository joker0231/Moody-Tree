//
//  userDateManager.swift
//  Moody Tree
//
//  Created by 王雨晨 on 2023/12/13.
//

import Foundation

struct UserDataManager {
    static let shared = UserDataManager()
    
    private let moodRecordCountKey = "moodRecordCount"
    private let todayMoodKey = "todayMood"
    private let dailyDataKey = "dailyDataKey"
    private let monthlyDataKey = "monthlyDataKey"
    private let nicknameKey = "nickname"
    
    func resetDailyData() {
        // 获取当前日期
        let currentDate = Date()
        
        // 获取 UserDefaults 中保存的日期
        if let savedDate = UserDefaults.standard.value(forKey: dailyDataKey) as? Date {
            let calendar = Calendar.current
            
            // 如果当前日期和保存的日期不在同一天，重置数据
            if !calendar.isDate(currentDate, inSameDayAs: savedDate) {
                UserDefaults.standard.set(currentDate, forKey: dailyDataKey)
                UserDefaults.standard.set(false, forKey: "checked")
                UserDefaults.standard.set("暂无", forKey: "todayMood")
                UserDefaults.standard.set(0, forKey: "moodRecordCount")
            }
        } else {
            // 如果之前没有保存过日期，保存当前日期
            UserDefaults.standard.set(currentDate, forKey: dailyDataKey)
            UserDefaults.standard.set(0, forKey: "moodRecordCount")
            UserDefaults.standard.set("暂无", forKey: "todayMood")
            UserDefaults.standard.set(false, forKey: "checked")
        }
    }
    
    func resetMonthlyData() {
        // 获取当前月份
        let currentDate = Date()
        
        // 获取 UserDefaults 中保存的月份
        if let savedMonth = UserDefaults.standard.value(forKey: "monthKey") as? Int {
            let calendar = Calendar.current
            
            // 如果当前月份和保存的月份不在同一个月，重置数据
            if calendar.component(.month, from: currentDate) != savedMonth {
                UserDefaults.standard.set(calendar.component(.month, from: currentDate), forKey: "monthKey")
                let defaultMonthlyData: [String: Int] = ["totalCount": 0, "negativeEmotionCount": 0, "positiveEmotionCount": 0, "happyCount": 0, "excitedCount": 0, "fightingCount": 0, "sadCount": 0, "speechlessCount": 0, "angryCount": 0, "tiredCount": 0, "exhaustedCount": 0]
                UserDefaults.standard.set(defaultMonthlyData, forKey: monthlyDataKey)
            }
        } else {
            let calendar = Calendar.current
            // 如果之前没有保存过月份，保存当前月份和重置数据
            UserDefaults.standard.set(calendar.component(.month, from: currentDate), forKey: "monthKey")
            
            let defaultMonthlyData: [String: Int] = ["totalCount": 0, "negativeEmotionCount": 0, "positiveEmotionCount": 0, "happyCount": 0, "excitedCount": 0, "fightingCount": 0, "sadCount": 0, "speechlessCount": 0, "angryCount": 0, "tiredCount": 0, "exhaustedCount": 0]
            UserDefaults.standard.set(defaultMonthlyData, forKey: monthlyDataKey)
        }
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
    
    func updateCheckInStatus() {
        // 检查是否已经签到
        guard !UserDefaults.standard.bool(forKey: "checked") else {
            return
        }

        // 更新 totalCount
        incrementMonthlyDataCount(forKey: "totalCount")

        // 标记为已签到
        UserDefaults.standard.set(true, forKey: "checked")
    }
    
    func updatemoodRecordCount(moodRecordCount: Int) {
        UserDefaults.standard.set(moodRecordCount, forKey: moodRecordCountKey)
    }
    
    func updatetodayMood(todayMood: String) {
        UserDefaults.standard.set(todayMood, forKey: todayMoodKey)
    }
    
    func getDailyData() -> (moodRecordCount: Int, todayMood: String) {
        let moodRecordCount = UserDefaults.standard.integer(forKey: moodRecordCountKey)
        let todayMood = UserDefaults.standard.string(forKey: todayMoodKey) ?? "暂无"
        return (moodRecordCount, todayMood)
    }

    func getMonthlyData() -> [String: Int] {
        return UserDefaults.standard.dictionary(forKey: monthlyDataKey) as? [String: Int] ?? ["totalCount": 0,"negativeEmotionCount": 0, "positiveEmotionCount": 0, "happyCount": 0, "excitedCount": 0, "fightingCount": 0, "sadCount": 0, "speechlessCount": 0, "angryCount": 0, "tiredCount": 0, "exhaustedCount": 0]
    }
    
    func incrementMonthlyDataCount(forKey key: String) {
        // 获取当前月份的数据
        var monthlyData = getMonthlyData()

        // 更新对应键的值
        monthlyData[key, default: 0] += 1

        // 保存更新后的数据
        UserDefaults.standard.setValue(monthlyData, forKey: monthlyDataKey)
    }

    func createMoodDataArray() -> [MoodSumData] {
        let monthlyData = getMonthlyData()
        let moodDataArray = [
            MoodSumData(mood: "棒极了", count: monthlyData["happyCount"] ?? 0),
            MoodSumData(mood: "美滋滋", count: monthlyData["excitedCount"] ?? 0),
            MoodSumData(mood: "冲冲冲", count: monthlyData["fightingCount"] ?? 0),
            MoodSumData(mood: "好难过", count: monthlyData["sadCount"] ?? 0),
            MoodSumData(mood: "无语", count: monthlyData["speechlessCount"] ?? 0),
            MoodSumData(mood: "生气", count: monthlyData["angryCount"] ?? 0),
            MoodSumData(mood: "累死了", count: monthlyData["tiredCount"] ?? 0),
            MoodSumData(mood: "焦虑", count: monthlyData["exhaustedCount"] ?? 0),
        ]
        return moodDataArray
    }
    
    // 获取 nickname
    func getNickname() -> String {
        let nickname = UserDefaults.standard.string(forKey: nicknameKey) ?? "小树"
        return nickname
    }

    // 更新 nickname
    func updateNickname(_ newNickname: String) {
        UserDefaults.standard.set(newNickname, forKey: nicknameKey)
    }
}

extension UserDefaults {
    func increment(forKey key: String) {
        let count = integer(forKey: key)
        set(count + 1, forKey: key)
    }
}

