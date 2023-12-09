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
    var date: Date
    var count: Int
    var id: UUID = UUID()


    init(mood: String, month: Int, count: Int) {
        let calendar = Calendar.autoupdatingCurrent
        self.mood = mood
        self.date = calendar.date(from: DateComponents(year: 2020, month: month))!
        self.count = count
    }
}

struct LineMarkChartView: View {
    var data: [LineMarkData]
    
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
