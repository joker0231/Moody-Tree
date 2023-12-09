//
//  annualStatistics.swift
//  Moody Tree
//
//  Created by 王雨晨 on 2023/12/6.
//

import Foundation
import SwiftUI

struct AnnualStatisticsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let moodDataArray = [
        MoodSumData(mood: "Happy", count: 25),
        MoodSumData(mood: "Sad", count: 15),
        MoodSumData(mood: "Excited", count: 30),
        MoodSumData(mood: "Calm", count: 25),
        MoodSumData(mood: "Angry", count: 15),
        MoodSumData(mood: "Surprised", count: 30),
        MoodSumData(mood: "Bored", count: 30),
    ]
    
    
    var LineChartdata: [LineMarkData] = [
        LineMarkData(mood: "Happy", month: 1, count: 12),
        LineMarkData(mood: "Sad", month: 1, count: 8),
        LineMarkData(mood: "Angry", month: 1, count: 8),
        LineMarkData(mood: "Confused", month: 1, count: 1),
        // ...
        LineMarkData(mood: "Happy", month: 6, count: 8),
        LineMarkData(mood: "Sad", month: 6, count: 9),
        LineMarkData(mood: "Angry", month: 6, count: 18),
        LineMarkData(mood: "Confused", month: 6, count: 5),
        LineMarkData(mood: "Happy", month: 12, count: 4),
        LineMarkData(mood: "Sad", month: 12, count: 19),
        LineMarkData(mood: "Angry", month: 12, count: 0),
        LineMarkData(mood: "Confused", month: 12, count: 2),
    ]
    
    var body: some View {
        NavigationView{
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(red: 169/255, green: 196/255, blue: 148/255), .white]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)

                VStack{
                    HStack{
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "arrowshape.left.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color("F7FBF6")) // 设置箭头颜色
                                .padding(.leading)
                            
                            Text("年度分析")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color("F7FBF6"))
                                .padding(.trailing, 20)
                        }

                        Spacer()
                        
                        // 在这里添加其他控件
                    }
                        .padding(.horizontal)
                    
                    ScrollView {
                        // 月度情绪统计
                        DataBlock(title: "月度情绪统计", detail: "这里是小树的一些建议这里是小树的一些建议这里是小树的一些建议这里是小树的一些建议这里是小树的一些建议这里是小树的一些建议这里是小树的一些建议这里是小树的一些建议这里是小树的一些建议这里是小树的一些建议这里是小树的一些建议这里是小树的一些建议这里是小树的一些建议leading", color: Color("7B8B6F")){
                            LineMarkChartView(data: LineChartdata)
                        }
                            .background(Color(red: 247/255, green: 251/255, blue: 246/255))
                            .cornerRadius(10)
                            .padding(.horizontal,20)
                            .shadow(radius: 5)
                        
                        // 月度情绪统计
                        DataBlock(title: "月度情绪统计", detail: "这里是小树的一些建议这里是小树的一些建议这里是小树的一些建议这里是小树的一些建议这里是小树的一些建议这里是小树的一些建议这里是小树的一些建议这里是小树的一些建议这里是小树的一些建议这里是小树的一些建议这里是小树的一些建议这里是小树的一些建议这里是小树的一些建议leading", color: Color("7B8B6F")){
                            PieChartViewController()
                                .edgesIgnoringSafeArea(.all)
                                .frame(width: 275,height: 260)
                        }
                            .background(Color(red: 247/255, green: 251/255, blue: 246/255))
                            .cornerRadius(10)
                            .padding(.horizontal,20)
                            .shadow(radius: 5)
                        
                        // 月度情绪统计
                        DataBlock(title: "月度情绪统计", detail: "这里是小树的一些建议这里是小树的一些建议这里是小树的一些建议这里是小树的一些建议这里是小树的一些建议这里是小树的一些建议这里是小树的一些建议这里是小树的一些建议这里是小树的一些建议这里是小树的一些建议这里是小树的一些建议这里是小树的一些建议这里是小树的一些建议leading", color: Color("7B8B6F")){
                            RadarChartViewController()
                                .edgesIgnoringSafeArea(.all)
                                .frame(width: 275,height: 240)
                        }
                            .background(Color(red: 247/255, green: 251/255, blue: 246/255))
                            .cornerRadius(10)
                            .padding(.horizontal,20)
                            .shadow(radius: 5)
                    }
                }
            }
        }
            .navigationBarHidden(true)
    }
}

struct AnnualStatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnnualStatisticsView()
    }
}
