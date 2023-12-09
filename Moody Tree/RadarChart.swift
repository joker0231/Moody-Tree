//
//  RadarChartView.swift
//  Moody Tree
//
//  Created by 王雨晨 on 2023/12/6.
//

import SwiftUI
import UIKit
import DGCharts
 
class ViewController: UIViewController, AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
           return activities[Int(value) % activities.count]
       }
    
     
    //雷达图
    var chartView: RadarChartView!
     
    //雷达图每个维度的标签文字
    let activities = ["happy", "sad", "angry", "confused", "shocked", "speakless"]
     
    override func viewDidLoad() {
        super.viewDidLoad()
         
        //创建折线图组件对象
        chartView = RadarChartView()
        chartView.frame = CGRect(x: 0, y: 0, width: 335,height: 320)
        self.view.addSubview(chartView)
         
        //最小、最大刻度值
        let yAxis = chartView.yAxis
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = 100
        yAxis.labelCount = 4
        yAxis.drawLabelsEnabled = false //不显示刻度值
        
        //维度标签文字
        chartView.xAxis.valueFormatter = self
         
        //生成6条随机数据
        let dataEntries = (0..<6).map { (i) -> RadarChartDataEntry in
            return RadarChartDataEntry(value: Double(arc4random_uniform(50) + 50))
        }
        let chartDataSet = RadarChartDataSet(entries: dataEntries, label: "mood")
        //目前雷达图只包括1组数据
        let chartData = RadarChartData(dataSets: [chartDataSet])
         
        //设置雷达图数据
        chartView.data = chartData
        chartDataSet.setColor(.systemGreen) //线条颜色
        chartDataSet.lineWidth = 2 //线条粗细
        chartDataSet.fillColor = .systemGreen //填充颜色
        chartDataSet.fillAlpha = 0.4  //填充透明度
        chartDataSet.drawFilledEnabled = true  //启用填充色绘制
        chartDataSet.drawHighlightCircleEnabled = true
    }
}

struct RadarChartViewController: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = ViewController()
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Optional: Implement any update logic if needed
    }
}

struct RadarChartViewController_Previews: PreviewProvider {
    static var previews: some View {
        RadarChartViewController()
    }
}
