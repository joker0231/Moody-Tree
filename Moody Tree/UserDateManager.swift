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
        var monthlyData = getMonthlyData()
        
        // 获取 UserDefaults 中保存的月份
        if let savedMonth = UserDefaults.standard.value(forKey: "monthKey") as? Int {
            let calendar = Calendar.current
            
            // 如果当前月份和保存的月份不在同一个月，重置数据
            if calendar.component(.month, from: currentDate) != savedMonth {
                let data:[String: Int] = ["negativeEmotionCount": monthlyData["negativeEmotionCount"] ?? 0,"positiveEmotionCount": monthlyData["positiveEmotionCount"] ?? 0,"happyCount": monthlyData["happyCount"] ?? 0, "excitedCount": monthlyData["excitedCount"] ?? 0, "fightingCount": monthlyData["fightingCount"] ?? 0, "sadCount": monthlyData["sadCount"] ?? 0, "speechlessCount": monthlyData["speechlessCount"] ?? 0, "angryCount": monthlyData["angryCount"] ?? 0, "tiredCount": monthlyData["tiredCount"] ?? 0, "exhaustedCount": monthlyData["exhaustedCount"] ?? 0]
                let monthlySavedData: [String: [String: Int]] = ["\(savedMonth)": data]
                var anidata = UserDefaults.standard.array(forKey: "anidata") as? [[String: [String: Int]]] ?? []
                anidata.append(monthlySavedData)
                UserDefaults.standard.set(anidata, forKey: "anidata")
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
    
    func getAnilyData() -> [[String: [String: Int]]] {
        return UserDefaults.standard.dictionary(forKey: "anidata") as? [[String: [String: Int]]] ?? [["1":["negativeEmotionCount":0,"positiveEmotionCount":0, "happyCount": 0, "excitedCount": 0, "fightingCount": 0, "sadCount": 0, "speechlessCount": 0, "angryCount": 0, "tiredCount": 0, "exhaustedCount": 0]]]
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
    
    func createLineDataArray() -> [LineMarkData] {
        let aniData = getAnilyData()
        var lineMarkDataArray: [LineMarkData] = []

        for item in aniData {
            for (key, value) in item {
                let month = Int(key) ?? 0
                let negativeEmotionCount = value["negativeEmotionCount"] ?? 0
                let positiveEmotionCount = value["positiveEmotionCount"] ?? 0

                let negativeEmotionData = LineMarkData(mood: "negativeEmotion", month: month, count: negativeEmotionCount)
                let positiveEmotionData = LineMarkData(mood: "positiveEmotion", month: month, count: positiveEmotionCount)

                lineMarkDataArray.append(contentsOf: [negativeEmotionData, positiveEmotionData])
            }
        }

        return lineMarkDataArray
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
    
    func findMaxMoodAdvice() -> String {
        let monthlyData = UserDefaults.standard.dictionary(forKey: monthlyDataKey) as? [String: Int] ?? [:]

        let emotions = [
            "happyCount": "最近的状态很好哦，请继续保持！保持良好心情的秘诀在于注重自我关爱和积极心态。通过定期锻炼、良好的睡眠、健康饮食，我们可以维持身体和心理的平衡。同时，学会有效的压力管理和情绪释放，比如通过冥想、深呼吸或与朋友交流。培养感恩心情，关注正能量，欣赏生活中的美好瞬间也是保持好心情的重要方式。要学会接受不可控的因素，并专注于自己能够改变的事物。最终，保持乐观和积极的心态，将有助于建立稳定、愉悦的情绪状态。",
            "excitedCount": "最近的状态很好哦，请继续保持！保持良好心情的秘诀在于注重自我关爱和积极心态。通过定期锻炼、良好的睡眠、健康饮食，我们可以维持身体和心理的平衡。同时，学会有效的压力管理和情绪释放，比如通过冥想、深呼吸或与朋友交流。培养感恩心情，关注正能量，欣赏生活中的美好瞬间也是保持好心情的重要方式。要学会接受不可控的因素，并专注于自己能够改变的事物。最终，保持乐观和积极的心态，将有助于建立稳定、愉悦的情绪状态。",
            "fightingCount": "最近的状态很好哦，请继续保持！保持良好心情的秘诀在于注重自我关爱和积极心态。通过定期锻炼、良好的睡眠、健康饮食，我们可以维持身体和心理的平衡。同时，学会有效的压力管理和情绪释放，比如通过冥想、深呼吸或与朋友交流。培养感恩心情，关注正能量，欣赏生活中的美好瞬间也是保持好心情的重要方式。要学会接受不可控的因素，并专注于自己能够改变的事物。最终，保持乐观和积极的心态，将有助于建立稳定、愉悦的情绪状态。",
            "sadCount": "最近遇到难过的事情这么多吗？小树在面对难过时，认为接受情感是重要的一步。给自己时间去感受悲伤，不要强迫快速过渡。与亲友分享感受，寻找支持。寻求专业帮助，心理咨询有助于理清情感。尝试进行身体活动，如散步，有助于情绪释放。保持良好的自我护理，例如良好的睡眠和饮食，对于缓解难过情绪有积极作用。",
            "speechlessCount": "时常感觉到无语吗？当感到烦躁时，尝试进行深呼吸和冥想，有助于平复情绪。放慢步调，逐步完成任务，避免过分紧张。进行轻度运动，如散步，有助于释放紧张感。寻找适合自己的放松方式，如听音乐或看书。设立小目标，逐步完成，增加成就感。避免刺激物质，如咖啡因，以维持情绪稳定。",
            "angryCount": "别生气别生气，生气伤身体！对于生气，深呼吸和冷静思考是关键。暂时远离激发情绪的场景，给自己冷静的时间。尝试表达情感而非发泄，用“我感觉”来表达需求。与他人沟通前确认自己的感受，有效沟通能减少误解。找到适合的释放方式，如运动或写日记，有助于舒缓情绪。最重要的是学会宽容，接受不完美，这对平复愤怒情绪很有帮助。",
            "tiredCount": "最近有些太过于疲惫咯，感到疲惫时，首要是给自己充足的休息时间。有规律的小憩和充足的睡眠对恢复精力至关重要。合理安排工作和休息时间，避免长时间的连续工作。寻找喜欢的活动进行放松，如阅读、听音乐或散步。保持良好的饮食和饮水习惯，有助于提升身体能量。考虑与他人分享感受，寻求支持。",
            "exhaustedCount": "你最近有些焦虑哦，当面对焦虑时，可以尝试深呼吸冥想。专注呼吸可以减轻紧张感，帮助大脑平静。此外，通过规划逐步解决问题，你能够逐渐恢复掌控感。运动也是出色的焦虑缓解方式，释放身体紧张感，促进身心健康。保持社交联系同样重要，分享感受获得支持。培养正向生活习惯，规律作息、健康饮食和足够休息，对心理健康有益。"
        ]

        
        let validEmotions = ["happyCount", "excitedCount", "fightingCount", "sadCount", "speechlessCount", "angryCount", "tiredCount", "exhaustedCount"]

        guard let maxMoodKey = validEmotions.max(by: { monthlyData[$0]! < monthlyData[$1]! }) else {
            return "目前数据太少，小树没法分析哦"
        }

        return emotions[maxMoodKey] ?? "暂无数据"
    }
    
    func analyzeEmotionData() -> String {
        let aniData = getAnilyData()
        var instabilityCount = 0
        var negativeSum = 0
        var positiveSum = 0
        let instabilityDiagnosis = "最近情绪有些不稳定噢，维持情绪稳定需要综合考虑生活中的多个方面。但请记住每个人的情况都是独特的，可能需要不同的方法适应个体差异。例如你可以 建立一个稳定的日常生活，包括固定的作息时间、饮食和运动。规律的生活方式有助于维持身体和心理的平衡。也可以学习和使用一些心理健康技巧，如深呼吸、冥想和正念。这些技巧有助于缓解压力和焦虑，提高情绪稳定性。与亲朋好友保持联系，分享感受和经历。有人可以倾诉，分享问题，会使情绪更加稳定哦。如果情绪波动较大，可以考虑寻求专业心理健康帮助，如心理治疗或咨询。"
        let pessimismDiagnosis = "今年的状态不是很好噢，消极情绪在引领你的生活状态。小树有些方法或许可以帮到你，首先你可以使用积极的心理暗示，通过对自己说一些积极、励志的话语，改变思维模式。例如，“我能够克服困难”、“每一天都是新的开始”。其次制定一些小而可行的目标，逐步实现。每次成功都会带来一种成就感，有助于提升积极性；另外 运动有助于释放身体内的压力，同时会释放身体内的愉悦激素，提升心情，寻找一些让你感兴趣的活动，培养爱好。这不仅能让你更好地放松，还能提高生活的乐趣；最后如果负面情绪影响到了日常生活，考虑咨询专业心理医生或心理治疗师，他们可以提供专业的支持和指导。"

        for data in aniData {
            if let monthData = data.first?.value {
                let negativeEmotionCount = monthData["negativeEmotionCount"] ?? 0
                let positiveEmotionCount = monthData["positiveEmotionCount"] ?? 0

                negativeSum += negativeEmotionCount
                positiveSum += positiveEmotionCount

                if negativeEmotionCount > positiveEmotionCount {
                    instabilityCount += 1
                }
            }
        }

        var diagnosisResult = ""

        if instabilityCount >= 3 && negativeSum > positiveSum {
            return instabilityDiagnosis + pessimismDiagnosis
        }

        if negativeSum > positiveSum {
            return pessimismDiagnosis
        }

        if instabilityCount >= 3 {
            return instabilityDiagnosis
        }

        return "最近情绪很稳定噢，继续保持吧！情绪稳定有许多积极的好处，对个人的身体健康、心理健康以及日常生活都有正面的影响有助于维持身体的生理平衡，降低患病的风险。稳定的情绪可以提高免疫系统的功能，减少患病的可能性，还能使人更容易与他人建立良好的人际关系。稳定的情绪状态有助于沟通和解决冲突，提高人际交往的质量。同时有助于提高集中注意力和工作效率。相比于情绪波动较大的状态，情绪稳定的人更容易处理工作任务。它对个体的综合健康和幸福感都有着显著的积极影响。"
    }
    
    func analyzeEmotions() -> String {
        let emotions = [
            "happyCount": "最近的状态很好哦，请继续保持！保持良好心情的秘诀在于注重自我关爱和积极心态。通过定期锻炼、良好的睡眠、健康饮食，我们可以维持身体和心理的平衡。同时，学会有效的压力管理和情绪释放，比如通过冥想、深呼吸或与朋友交流。培养感恩心情，关注正能量，欣赏生活中的美好瞬间也是保持好心情的重要方式。要学会接受不可控的因素，并专注于自己能够改变的事物。最终，保持乐观和积极的心态，将有助于建立稳定、愉悦的情绪状态。",
            "excitedCount": "最近的状态很好哦，请继续保持！保持良好心情的秘诀在于注重自我关爱和积极心态。通过定期锻炼、良好的睡眠、健康饮食，我们可以维持身体和心理的平衡。同时，学会有效的压力管理和情绪释放，比如通过冥想、深呼吸或与朋友交流。培养感恩心情，关注正能量，欣赏生活中的美好瞬间也是保持好心情的重要方式。要学会接受不可控的因素，并专注于自己能够改变的事物。最终，保持乐观和积极的心态，将有助于建立稳定、愉悦的情绪状态。",
            "fightingCount": "最近的状态很好哦，请继续保持！保持良好心情的秘诀在于注重自我关爱和积极心态。通过定期锻炼、良好的睡眠、健康饮食，我们可以维持身体和心理的平衡。同时，学会有效的压力管理和情绪释放，比如通过冥想、深呼吸或与朋友交流。培养感恩心情，关注正能量，欣赏生活中的美好瞬间也是保持好心情的重要方式。要学会接受不可控的因素，并专注于自己能够改变的事物。最终，保持乐观和积极的心态，将有助于建立稳定、愉悦的情绪状态。",
            "sadCount": "最近遇到难过的事情这么多吗？小树在面对难过时，认为接受情感是重要的一步。给自己时间去感受悲伤，不要强迫快速过渡。与亲友分享感受，寻找支持。寻求专业帮助，心理咨询有助于理清情感。尝试进行身体活动，如散步，有助于情绪释放。保持良好的自我护理，例如良好的睡眠和饮食，对于缓解难过情绪有积极作用。",
            "speechlessCount": "时常感觉到无语吗？当感到烦躁时，尝试进行深呼吸和冥想，有助于平复情绪。放慢步调，逐步完成任务，避免过分紧张。进行轻度运动，如散步，有助于释放紧张感。寻找适合自己的放松方式，如听音乐或看书。设立小目标，逐步完成，增加成就感。避免刺激物质，如咖啡因，以维持情绪稳定。",
            "angryCount": "别生气别生气，生气伤身体！对于生气，深呼吸和冷静思考是关键。暂时远离激发情绪的场景，给自己冷静的时间。尝试表达情感而非发泄，用“我感觉”来表达需求。与他人沟通前确认自己的感受，有效沟通能减少误解。找到适合的释放方式，如运动或写日记，有助于舒缓情绪。最重要的是学会宽容，接受不完美，这对平复愤怒情绪很有帮助。",
            "tiredCount": "最近有些太过于疲惫咯，感到疲惫时，首要是给自己充足的休息时间。有规律的小憩和充足的睡眠对恢复精力至关重要。合理安排工作和休息时间，避免长时间的连续工作。寻找喜欢的活动进行放松，如阅读、听音乐或散步。保持良好的饮食和饮水习惯，有助于提升身体能量。考虑与他人分享感受，寻求支持。",
            "exhaustedCount": "你最近有些焦虑哦，当面对焦虑时，可以尝试深呼吸冥想。专注呼吸可以减轻紧张感，帮助大脑平静。此外，通过规划逐步解决问题，你能够逐渐恢复掌控感。运动也是出色的焦虑缓解方式，释放身体紧张感，促进身心健康。保持社交联系同样重要，分享感受获得支持。培养正向生活习惯，规律作息、健康饮食和足够休息，对心理健康有益。"
        ]

        // 根据最大情绪返回对应的文字内容
        return emotions[calculateAniMaxValue().maxKey] ?? "目前数据太少，小树没法分析哦"
    }
    
    func calculateAniMaxValue() -> (maxValue: Int,maxKey: String){
        let aniData = getAnilyData()
        var emotionSums: [String: Int] = [:]
        
        for dataEntry in aniData {
            for (_, emotionData) in dataEntry {
                // 遍历每个属性的值，除了negativeEmotionCount和positiveEmotionCount
                for (emotion, count) in emotionData where emotion != "negativeEmotionCount" && emotion != "positiveEmotionCount" {
                    // 将属性值累加到总和中
                    emotionSums[emotion, default: 0] += count
                }
            }
        }
        
        let maxValue = emotionSums.values.max()!
        let maxKey = emotionSums.first { $0.value == maxValue }!.key
        return (maxValue,maxKey)
    }
    
    func analyzeKeyWord() -> String {
        let emotions = [
            "happyCount": "在这一年的光阴里，你是那位始终挂着开心笑容的人。即便生活的风风雨雨，你总是努力寻找其中的快乐点滴，把欢笑的音符散播给周围的每一个人。从独处时的微笑到与朋友分享的快乐时光，开心成为你独特的标志，也温暖了整个年度。",
            "excitedCount": "这是一个激动人心的一年，充满了激情与挑战。每一次的冒险都让你心跳不已，激动地品味着生活的美好。新的经历、新的机遇，都让你兴奋不已，成为年度里最难以忘怀的记忆。",
            "fightingCount": "以奋斗为信仰，你在这一年里为自己设定了更高的目标。在职场、学业，甚至是个人发展的每个领域，你都付出了极大的努力。那种奋发向前的精神，成就了你不平凡的一年。",
            "sadCount": "难过是人生中无法回避的一部分，而你在这一年里深刻地感受到了这份情绪。或许是因为失落，或许是因为不如意的局面，但难过并不是软弱的象征，而是内心坚韧的体现。你学会了接纳这些难过，并从中汲取力量。",
            "angryCount": "今年，你为了维护正义和原则而愤怒。生气是对不公平的回应，是对错误的抗议。你勇敢表达自己的不满，为了自己和他人的权益而奋力一搏。生气不是软弱，而是为了更好的未来而发声。",
            "tiredCount": "疲惫是奋斗者的标志，是你为梦想拼搏的必然付出。在这一年里，你可能感受到了身心俱疲的瞬间，但每一份努力都是值得的。疲惫是暂时的，而成功的喜悦会延续更久。",
            "exhaustedCount": "焦虑是现代生活中难以避免的伴侣，今年你也深刻体验了这一情感。或许是来自事业的压力，或许是对未来的担忧。但在认知焦虑的源头的过程中，你为自己找到了更多的平静与解脱。"
        ]
        
        
        return emotions[calculateAniMaxValue().maxKey] ?? "目前数据太少，小树没法分析哦"
    }
}

