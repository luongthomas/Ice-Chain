//
//  GraphExecuted.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 9/15/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import UIKit
import Charts

class LineChart2ViewController: DemoBaseViewController {
    
    @IBOutlet var chartView: LineChartView!
    
    @IBOutlet weak var doneButton: Button!
    @IBOutlet weak var statusLabel: UILabel!
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (State.downloadReport) {
            doneButton.setTitle("Go Back", for: .normal)
        }
        
        // Do any additional setup after loading the view.
        self.title = CurrentContract.shared.contractName
        
        chartView.delegate = self
        
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
        
        // x-axis limit line
        let llXAxis = ChartLimitLine(limit: 500, label: "Index 500")
        llXAxis.lineWidth = 4
        llXAxis.lineDashLengths = [10, 10, 0]
        llXAxis.labelPosition = .rightBottom
        llXAxis.valueFont = .systemFont(ofSize: 10)
        
        chartView.xAxis.gridLineDashLengths = [10, 10]
        chartView.xAxis.gridLineDashPhase = 0
        
        let ll1 = ChartLimitLine(limit: 150, label: "Upper Limit")
        ll1.lineWidth = 4
        ll1.lineDashLengths = [5, 5]
        ll1.labelPosition = .rightTop
        ll1.valueFont = .systemFont(ofSize: 10)
        
        let ll2 = ChartLimitLine(limit: -30, label: "Lower Limit")
        ll2.lineWidth = 4
        ll2.lineDashLengths = [5,5]
        ll2.labelPosition = .rightBottom
        ll2.valueFont = .systemFont(ofSize: 10)
        
        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
//        leftAxis.addLimitLine(ll1)
//        leftAxis.addLimitLine(ll2)
        leftAxis.axisMaximum = 3
        leftAxis.axisMinimum = -2
        leftAxis.gridLineDashLengths = [5, 5]
        leftAxis.drawLimitLinesBehindDataEnabled = true
        
        chartView.rightAxis.enabled = false
        
        //[_chartView.viewPortHandler setMaximumScaleY: 2.f];
        //[_chartView.viewPortHandler setMaximumScaleX: 2.f];
        
//        let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1),
//                                   font: .systemFont(ofSize: 12),
//                                   textColor: .white,
//                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
//        marker.chartView = chartView
//        marker.minimumSize = CGSize(width: 80, height: 40)
//        chartView.marker = marker

        
        chartView.legend.form = .line
        chartView.animate(xAxisDuration: 2.5)
        
        self.updateChartData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scheduledTimerWithTimeInterval()
    }
    
    
    func scheduledTimerWithTimeInterval(){
        // Change delay in seconds here
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    @objc func update() {
        self.updateChartData()
    }
    
    override func updateChartData() {
        if self.shouldHideData {
            chartView.data = nil
            return
        }
        
        if State.tempArray.count > 20 {
            self.setDataCount(State.tempArray.count, range: UInt32(10))
        }
    }
    
    func setDataCount(_ count: Int, range: UInt32) {
        var values = [ChartDataEntry]()
        var min = 0.0
        var max = 0.0
        
        if State.tempArray.count > 20 {
            values = (0..<count).map { (i) -> ChartDataEntry in
                let val = State.tempArray[i]
                if val > max {
                    max = val
                }
                
                if val < min {
                    min = val
                }
                
                if val > CurrentContract.shared.maxTemperature {
                    statusLabel.text = "Contract Failed: Value \(val) is larger than the maximum temperature of \(CurrentContract.shared.maxTemperature)"
                }
                
                if val < CurrentContract.shared.minTemperature {
                    statusLabel.text = "Contract Failed: Value \(val) is larger than the minimum temperature of \(CurrentContract.shared.minTemperature)"
                }
                
                return ChartDataEntry(x: Double(i), y: val, icon: #imageLiteral(resourceName: "icon"))
            }
        } else {
            values = (0..<count).map { (i) -> ChartDataEntry in
                // TODO: GET DATA HERE
                
                let val  = Double.random(min: 1.9, max: 2.1)
                if val > max {
                    max = val
                }
                
                if val < min {
                    min = val
                }
                return ChartDataEntry(x: Double(i), y: val, icon: #imageLiteral(resourceName: "icon"))
            }
        }
        
        let set1 = LineChartDataSet(values: values, label: "DataSet 1")
        set1.drawIconsEnabled = false
        
        set1.lineDashLengths = [5, 2.5]
        set1.highlightLineDashLengths = [5, 2.5]
        set1.setColor(.black)
        set1.setCircleColor(.black)
        set1.lineWidth = 1
        set1.circleRadius = 3
        set1.drawCircleHoleEnabled = false
//        set1.valueFont = .systemFont(ofSize: 9)
        set1.formLineDashLengths = [5, 2.5]
        set1.formLineWidth = 1
        set1.formSize = 15
        
        let yAxis = chartView.getAxis(.left)
        yAxis.axisMaximum = max + 5.0
        yAxis.axisMinimum = min - 5.0
        let xAxis = chartView.xAxis
        xAxis.axisMaximum = Double(State.tempArray.count)
        
        let data = LineChartData(dataSet: set1)
        chartView.data = data
        
    }
    
    @IBAction func handleDonePress(_ sender: Any) {
        guard let buttonText = doneButton.titleLabel!.text else { return }
        
        let dialogUtil = DialogUtility()
        if buttonText == "Done" {
            NetworkUtility().sendTemperatures(contractId: CurrentContract.shared._id, tempArray: State.tempArray) { (status, err) in
                if let err = err {
                    let errMsg = "Error in uploading temperatures to Smart Contract: \(err)"
                    dialogUtil.displayMyAlertMessage(vc: self, userMessage: errMsg)
                    print(errMsg)
                    self.doneButton.setTitle("Go Back", for: .normal)
                    return
                }
                
                switch (status) {
                case "Contract Success":
                    self.statusLabel.text = "Successful Smart Contract. Updated successfully"
                case "Contract Failed":
                    self.statusLabel.text = "Failed Smart Contract.  Updated successfully."
                default:
                    self.statusLabel.text = "Unknown contract status"
                }
                
                self.doneButton.setTitle("Go Back", for: .normal)
            }
        }
    
        if buttonText == "Go Back" {
            dismiss(animated: true, completion: nil)
        }
    }
}
