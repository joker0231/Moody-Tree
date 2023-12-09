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
     
    //饼状图
    var chartView: PieChartView!
     
    override func viewDidLoad() {
        super.viewDidLoad()
         
        //创建饼图组件对象
        chartView = PieChartView()
        chartView.frame = CGRect(x: 20, y: 0, width: 285,height: 260)
        self.view.addSubview(chartView)
         
        //生成5条随机数据
        let dataEntries = (0..<5).map { (i) -> PieChartDataEntry in
            return PieChartDataEntry(value: Double(arc4random_uniform(50) + 10),
                                     label: "数据\(i)")
        }
        let chartDataSet = PieChartDataSet(entries: dataEntries, label: "")
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

