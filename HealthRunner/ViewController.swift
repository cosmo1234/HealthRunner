//
//  ViewController.swift
//  HealthRunner
//
//  Created by sagaya Abdulhafeez on 19/06/2016.
//  Copyright © 2016 sagaya Abdulhafeez. All rights reserved.
//

import UIKit
import CoreMotion
import Spring

class ViewController: UIViewController {

    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view1: UIView!
    
    
    @IBOutlet weak var currentDate: UILabel!
    @IBOutlet weak var calories: UILabel!
    @IBOutlet weak var steps: UILabel!
    @IBOutlet weak var state: UILabel!
    
    var days:[String] = []
    var stepsTake:[Int] = []
    
    let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        circleViews(view3)
        circleViews(view2)
        circleViews(view1)
        updateDate()
        
        
        let cal = NSCalendar.currentCalendar()
        var comps = cal.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: NSDate() )
        comps.hour = 0
        comps.minute = 0
        comps.second = 0
        let timezone = NSTimeZone.systemTimeZone()
        comps.timeZone = timezone
        
        let midnightOfToday = cal.dateFromComponents(comps)
        
        //Check motion state
        
        if CMMotionActivityManager.isActivityAvailable(){
            
            self.activityManager.startActivityUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (data) in
                
                if data?.stationary == true {
                    self.state.text = "Stationary"
                    
                }else if data?.walking == true{
                    self.state.text = "Walking"
                }else if data?.running == true{
                    self.state.text = "Running"
                }else if data?.automotive == true{
                    self.state.text = "Automotive"
                }
                
            })
            
        }
        
        //Count steps
        
        if CMPedometer.isStepCountingAvailable(){
            let fromDate = NSDate(timeIntervalSinceNow: -86400 * 7)
            pedometer.queryPedometerDataFromDate(fromDate, toDate: NSDate(), withHandler: { (data, error) in
                
                if error != nil{
                    print(error.debugDescription)
                }else{
                    
                    self.steps.text = "\(data?.numberOfSteps)"

                }
                
            })
            
            self.pedometer.startPedometerUpdatesFromDate(midnightOfToday!, withHandler: { (data, error) in
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if(error == nil){
                        self.steps.text = "\(data!.numberOfSteps)"
                        
                        if self.steps.text != nil{
                            self.calories.text = "\(Int(self.steps.text!)!/12)"
                            
                            
                        }
                        
                    }
                })

                
            })
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func updateDate(){
        
        let date = NSDate()
        let formarter = NSDateFormatter()
        formarter.dateFormat = "yyy-MM-dd HH:mm:ss ZZZ"
        formarter.dateStyle = NSDateFormatterStyle.LongStyle
        
        formarter.locale = NSLocale.currentLocale()
        
        var coDate = formarter.stringFromDate(date)
        
        
//        let calendar = NSCalendar.currentCalendar()
//        let component = calendar.components([.Day, .Month, .Year], fromDate: date)
//        
//        let year = component.year
//        let month = component.month
//        let day = component.day
//        
        
        
//        let dateString = "\(day)/\(month)/\(year)"
        currentDate.text = coDate
        
    }
    
    
    func circleViews(view: UIView){
        view.layer.cornerRadius = view.frame.height/2
        view.clipsToBounds = true
    }
    
  

}

