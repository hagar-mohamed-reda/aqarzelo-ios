//
//  AqarDetailChartsCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/8/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import WebKit

class AqarDetailChartsCell: BaseCollectionCell {
    
    var postId:Int?{
        didSet {
            guard let post = postId ,let myURL = URL(string:"http://aqarzelo.com/public/chart?post_id=\(post)".toSecrueHttps()) else {return}
            let myRequest = URLRequest(url: myURL)
            mainWebView.load(myRequest)
        }
    }
//    1580644565
    
    lazy var mainWebView:WKWebView = {
        let v = WKWebView()
        v.uiDelegate = self
       
//        v.load(myRequest)
        return v
    }()
//    var xData:[String]! {
//        didSet {
//            lineChartView.x.grid.count = CGFloat(xData.count)
//        }
//    }
//
//
//    lazy var lineChartView:LineChart = {
//        let v = LineChart()
//
//        // simple arrays
//        let data: [CGFloat] = [3, 4, -2, 11, 13, 15]
//        let data2: [CGFloat] = [1, 3, 5, 13, 17, 20]
//
//        // simple line with custom x axis labels
//        let xLabels: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
//
//        v.animation.enabled = true
//        v.area = true
////        lineChart.x.labels.visible = true
//        v.area = false
////        v.x.grid.count = CGFloat(xData.count)
//        v.y.grid.count = 10
//        v.addLine([3, 4, 9, 11, 13, 15])
//        v.addLine([5, 4, 3, 6, 6, 7])
////    v.delegate = self
////        v.
//        return v
//    }()
//
//   var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
//    let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
//
//
//    lazy var mainLineChartsView:LineChartView = {
//       let v = LineChartView()
//        v.noDataText = "no data avaiable!"
//        return v
//    }()
//
    override func setupViews() {
        backgroundColor = .white
        
        stack(mainWebView)
    }
    
  
}

extension AqarDetailChartsCell: WKUIDelegate {
    
    
}
