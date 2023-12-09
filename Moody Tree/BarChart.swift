//
//  BarChart.swift
//  Moody Tree
//
//  Created by 王雨晨 on 2023/12/5.
//

import SwiftUI
import Charts

struct BarMarkData: Identifiable {
    let mood: String
    let count: Int
    var id: String{mood}
}

struct BarMarkChartView: View {
    var data: [MoodSumData] // Replace YourExternalDataStruct with the actual type of your external data

    var defData: [BarMarkData] {
        data.map { BarMarkData(mood: $0.mood, count: $0.count) }
    }
    
    var body: some View {
        Chart(defData) {
            BarMark(
                x: .value("mood", $0.mood),
                y: .value("count", $0.count)
            )
        }
        .frame(width: 315, height: 160)
        .colorMultiply(Color(red: 123/255, green: 196/255, blue: 81/255))
    }
}

struct BarMarkChartView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
