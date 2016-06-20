//
//  charttViewController.swift
//  
//
//  Created by sagaya Abdulhafeez on 19/06/2016.
//
//

import UIKit
import Charts
import CoreMotion

class charttViewController: UIViewController,ChartViewDelegate {

    @IBOutlet weak var chartView: BarChartView!
    
    var days:[String] = []
    var stepsTaken:[Int] = []
    let activityManager = CMMotionActivityManager()
    let pedoMeter = CMPedometer()
    
    var cnt = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        chartView.descriptionText = ""
        chartView.noDataTextDescription = "Data will be loaded soon."
        
        chartView.drawBarShadowEnabled = false
        chartView.drawValueAboveBarEnabled = true
        
        chartView.maxVisibleValueCount = 60
        chartView.pinchZoomEnabled = true
        chartView.drawGridBackgroundEnabled = true
        chartView.drawBordersEnabled = false
        chartView.clipsToBounds = true
        
        getDataForLastWeek()
        
    }
    
    
    func getDataForLastWeek(){
        
        if CMPedometer.isStepCountingAvailable() {
            var serialQueue : dispatch_queue_t  = dispatch_queue_create("com.example.MyQueue", nil)
            let formatter = NSDateFormatter()
            formatter.dateFormat = "d MMM"
            
            dispatch_sync(serialQueue, { () -> Void in
              
                let today = NSDate()
                
                for day in 0...6{
                    
                    let fromDate = NSDate(timeIntervalSinceNow: Double(-7 + day) * 86400 )
                    let toDate = NSDate(timeIntervalSinceNow: Double(-7+day+1) * 86400)
                    let dtStr = formatter.stringFromDate(toDate)
                    
                    self.pedoMeter.queryPedometerDataFromDate(fromDate, toDate: toDate, withHandler: { (data, error) in
                        
                        if error == nil{
                            print("\(dtStr) : \(data!.numberOfSteps)")
                            self.days.append(dtStr)
                            self.stepsTaken.append(Int((data?.numberOfSteps)!))
                            
                            print("Days :\(self.days)")
                            print("Steps :\(self.stepsTaken)")
                            
                            if self.days.count == 7{
                                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                                    
                                    let xvals = self.days
                                    var yvals:[BarChartDataEntry] = []
                                    
                                    for idx in 0...6 {
                                        yvals.append(BarChartDataEntry(value: Double(self.stepsTaken[idx]), xIndex: idx))
                                    }
                                    
                                    print("Days :\(self.days)")
                                    print("Steps :\(self.stepsTaken)")
                                    
                                    let set1 = BarChartDataSet(yVals: yvals, label: "Steps Taken")
                                    set1.barSpace = 0.25
                                    
                                    let data = BarChartData(xVals: xvals, dataSet: set1)
                                    data.setValueFont(UIFont(name: "Avenir", size: 12))
                                    self.chartView.data = data
                                    self.view.reloadInputViews()
                                })
                            }

                        }
                        
                    })
                    
                }
                
            })
            
            
        }
        
    }


    @IBAction func back(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
