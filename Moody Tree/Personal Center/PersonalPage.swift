//
//  PersonalPage.swift
//  Moody Tree
//
//  Created by 王雨晨 on 2023/12/5.
//

import SwiftUI

struct MoodSumData: Identifiable {
    let mood: String
    let count: Int
    var id: String{mood}
}

struct ProfileView: View {
    @State private var monthlyData: [String: Int] = ["totalCount": 0,"negativeEmotionCount": 0, "positiveEmotionCount": 0, "happyCount": 0, "excitedCount": 0, "fightingCount": 0, "sadCount": 0, "speechlessCount": 0, "angryCount": 0, "tiredCount": 0, "exhaustedCount": 0]
    @State private var nickname: String = "小树"
    @State private var moodDataArray: [MoodSumData] = [
        MoodSumData(mood: "棒极了", count: 0),
        MoodSumData(mood: "美滋滋", count: 0),
        MoodSumData(mood: "冲冲冲", count: 0),
        MoodSumData(mood: "好难过", count: 0),
        MoodSumData(mood: "无语", count: 0),
        MoodSumData(mood: "生气", count: 0),
        MoodSumData(mood: "累死了", count: 0),
        MoodSumData(mood: "焦虑", count: 0),
    ]
    
    var body: some View {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(red: 169/255, green: 196/255, blue: 148/255), .white]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    // 头像和昵称
                    Image(systemName: "person.circle.fill") // 需要替换为真实的头像
                        .resizable()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .padding(.top, 35)

                    Text(nickname)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color(red: 247/255, green: 251/255, blue: 246/255))
                        .padding(.top, 10)

                    // 数据统计部分
                    HStack {
                        SumBlock(data: monthlyData["positiveEmotionCount"] ?? 0, detail: "次小树健康成长", color: Color("7B8B6F"))
                        Divider().frame(height: 60).background(Color("7B8B6F"))
                        SumBlock(data: monthlyData["negativeEmotionCount"] ?? 0, detail: "次小树遭受磨难", color: Color("7B8B6F"))
                        Divider().frame(height: 60).background(Color("7B8B6F"))
                        SumBlock(data: monthlyData["totalCount"] ?? 0, detail: "次的辛勤灌溉", color: Color("7B8B6F"))
                    }
                    .padding(18)
                    .background(Color(red: 247/255, green: 251/255, blue: 246/255))
                    .cornerRadius(10)

                    // 月度情绪统计
                    DataBlock(title: "月度情绪统计", detail: "截止到今日，本月你的情绪统计如下：", color: Color("7B8B6F")){
                        BarMarkChartView(data: moodDataArray)
                    }
                        .background(Color(red: 247/255, green: 251/255, blue: 246/255))
                        .cornerRadius(10)
                        .padding(.horizontal, 25)
                        .shadow(radius: 5)
                    

                    // 小树想帮你
                    DataBlock(title: "小树想帮你", detail: UserDataManager.shared.findMaxMoodAdvice(), color: Color("7B8B6F")){
                        EmptyView()
                    }
                        .background(Color(red: 247/255, green: 251/255, blue: 246/255))
                        .cornerRadius(10)
                        .padding(.horizontal, 25)
                        .shadow(radius: 5)
                    
                    ConfigBlock()
                        .cornerRadius(10)
                        .padding(.horizontal, 25)
                        .shadow(radius: 5)
                    
                    Spacer().frame(height: 30)
                }
            }
            .onAppear{
                monthlyData = UserDataManager.shared.getMonthlyData()
                nickname = UserDataManager.shared.getNickname()
                moodDataArray = UserDataManager.shared.createMoodDataArray()
                UserDataManager.shared.resetMonthlyData()
            }
        }
}

struct SumBlock: View {
    var data: Int
    var detail: String
    var color: Color

    var body: some View {
            VStack(spacing: 5) {
                Text("\(data)")
                    .font(.system(size: 24,weight: .bold))
                    .foregroundColor(color)
                    .lineLimit(1)
                    .padding(.trailing, 5)

                Text(detail)
                    .font(.system(size: 14))
                    .foregroundColor(Color("7B8B6F"))
            }
    }
}

struct ConfigBlock: View {
    var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                NavigationLink(destination: AnnualStatisticsView()) {
                    Text("年度统计")
                        .font(.system(size: 16))
                        .foregroundColor(Color("7B8B6F"))
                        .padding(.bottom, 5)
                }
                
                Divider().frame(height: 1).background(Color("7B8B6F"))
                
                
                NavigationLink(destination: ConfigPageView()) {
                    Text("设置")
                        .font(.system(size: 16))
                        .foregroundColor(Color("7B8B6F"))
                        .padding(.bottom, 5)
                        .padding(.top, 15)
                }

                Divider().frame(height: 1).background(Color("7B8B6F"))
            }
            .padding(20)
            .cornerRadius(10)
            .background(Color.white.cornerRadius(10))
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

extension Color {
    init(_ hex: String) {
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0

        if scanner.scanHexInt64(&rgb) {
            self.init(
                red: Double((rgb & 0xFF0000) >> 16) / 255.0,
                green: Double((rgb & 0x00FF00) >> 8) / 255.0,
                blue: Double(rgb & 0x0000FF) / 255.0
            )
        } else {
            self.init(red: 0, green: 0, blue: 0)
        }
    }
}

