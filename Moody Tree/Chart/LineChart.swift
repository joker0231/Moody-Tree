//
//  LineChart.swift
//  Moody Tree
//
//  Created by 王雨晨 on 2023/12/6.
//

import Foundation
import SwiftUI
import Charts

struct LineMarkData: Identifiable {
    var mood: String
    var date: Int
    var count: Int
    var id: UUID = UUID()


    init(mood: String, month: Int, count: Int) {
        self.mood = mood
        self.date = month
        self.count = count
    }
}

struct LineMarkChartView: View {
    let data = [
        LineMarkData(mood: "negativeEmotion", month: 1, count: 11),
        LineMarkData(mood: "positiveEmotion", month: 1, count: 10),
        LineMarkData(mood: "negativeEmotion", month: 2, count: 12),
        LineMarkData(mood: "positiveEmotion", month: 2, count: 3),
        LineMarkData(mood: "negativeEmotion", month: 3, count: 10),
        LineMarkData(mood: "positiveEmotion", month: 3, count: 13),
        LineMarkData(mood: "negativeEmotion", month: 4, count: 6),
        LineMarkData(mood: "positiveEmotion", month: 4, count: 18),
        LineMarkData(mood: "negativeEmotion", month: 5, count: 10),
        LineMarkData(mood: "positiveEmotion", month: 5, count: 10),
    ]
    
    var body: some View {
        Chart(data) {
            LineMark(
                x: .value("Month", $0.date),
                y: .value("MoodCount", $0.count)
            )
            .foregroundStyle(by: .value("Mood", $0.mood))
        }
        .frame(width: 315, height: 160)
    }
}

struct LineMarkChartView_Previews: PreviewProvider {
    static var previews: some View {
        AnnualStatisticsView()
    }
}
