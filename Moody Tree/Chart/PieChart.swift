//
//  PieChart.swift
//  Moody Tree
//
//  Created by 王雨晨 on 2023/12/6.
//

import SwiftUI
import DGCharts
import UIKit

class PieViewController: UIViewController {
    let anidata = UserDataManager.shared.getAnilyData()
    
    func calculateEmotionSum() -> [PieChartDataEntry] {
        var emotionSums: [String: Int] = [:]
        let anidata = UserDataManager.shared.getAnilyData()

        // 遍历anidata的每个item
        for dataEntry in anidata {
            for (_, emotionData) in dataEntry {
                // 遍历每个属性的值，除了negativeEmotionCount和positiveEmotionCount
                for (emotion, count) in emotionData where emotion != "negativeEmotionCount" && emotion != "positiveEmotionCount" {
                    // 将属性值累加到总和中
                    emotionSums[emotion, default: 0] += count
                }
            }
        }

        // 将总和转换成PieChartDataEntry数组
        let pieChartDataEntries: [PieChartDataEntry] = emotionSums.map {
            PieChartDataEntry(value: Double($0.value), label: $0.key)
        }

        return pieChartDataEntries
    }
     
    //饼状图
    var chartView: PieChartView!
     
    override func viewDidLoad() {
        super.viewDidLoad()
         
        //创建饼图组件对象
        chartView = PieChartView()
        chartView.frame = CGRect(x: 10, y: 0, width: 305,height: 270)
        self.view.addSubview(chartView)
         
        let chartDataSet = PieChartDataSet(entries: calculateEmotionSum(), label: "")
        //设置颜色
        chartDataSet.colors = ChartColorTemplates.liberty()
        let chartData = PieChartData(dataSet: chartDataSet)
         
        //设置饼状图数据
        chartView.data = chartData
        chartDataSet.sliceSpace = 3 //扇区间隔为3
        chartDataSet.xValuePosition = .outsideSlice //标签显示在外
        chartDataSet.yValuePosition = .insideSlice //数值显示在内
        chartData.setValueTextColor(.black)//文字颜色为黑色
    }
}

struct PieChartViewController: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = PieViewController()
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Optional: Implement any update logic if needed
    }
}

struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        AnnualStatisticsView()
    }
}

