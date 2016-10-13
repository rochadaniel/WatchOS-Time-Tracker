//
//  InterfaceController.swift
//  Timer Tracker WatchKit Extension
//
//  Created by Daniel Rocha on 13/10/16.
//  Copyright © 2016 Daniel Rocha. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var topLabel: WKInterfaceLabel!
    @IBOutlet var middleLabel: WKInterfaceLabel!
    @IBOutlet var button: WKInterfaceButton!
    
    var clockedIn = false
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    
        // Configure interface objects here.
        updateUI(clockedIn: clockedIn)
    }
    
    func updateUI(clockedIn: Bool) {
        if clockedIn {
            //THE UI FOR WHEN SOMEONE IS CLOCKED IN
            topLabel.setHidden(false)
            middleLabel.setText("Today\n5m 22s")
            button.setTitle("Clocked-Out")
            button.setBackgroundColor(UIColor.red)
        } else {
            //THE UI FOR WHEN SOMEONE IS CLOCKED OUT
            topLabel.setHidden(true)
            middleLabel.setText("Today\n3h 44m")
            button.setTitle("Clocked-In")
            button.setBackgroundColor(UIColor.green)
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func clockInOutTapped() {
        if clockedIn {
            clockOut()
        } else {
            clockIn()
        }
        updateUI(clockedIn: clockedIn)
    }
    
    func clockIn() {
        clockedIn = true
        
        UserDefaults.standard.set(Date(), forKey: "clockedIn")
        UserDefaults.standard.synchronize()
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {(timer) in
            if let clockedInDate = UserDefaults.standard.value(forKey: "clockedIn") as? Date {
                let timeInterval = Int(Date().timeIntervalSince(clockedInDate))
                print(timeInterval)
                
                let hours = timeInterval / 3600
                let minutes = (timeInterval % 3600) / 60
                let seconds = timeInterval % 60
                
                self.middleLabel.setText("\(hours)h \(minutes)m \(seconds)s")   
            }
        })
    }
    
    func clockOut() {
        clockedIn = false
        if let clockedInDate = UserDefaults.standard.value(forKey: "clockedIn") as? Date {
            // Adding the clockin time to the clockIns array
            if var clockIns = UserDefaults.standard.array(forKey: "clockIns") as? [Date] {
                clockIns.insert(clockedInDate, at: 0)
                UserDefaults.standard.set(clockIns, forKey: "clockIns")
                print(clockIns)
            } else {
                //FIRST TIME
                UserDefaults.standard.set([clockedInDate], forKey: "clockIns")
            }
            
            // Adding the clockout time to the clockOuts array
            if var clockOuts = UserDefaults.standard.array(forKey: "clockOuts") as? [Date] {
                clockOuts.insert(Date(), at: 0)
                UserDefaults.standard.set(clockOuts, forKey: "clockOuts")
                print(clockOuts)
            } else {
                //FIRST TIME
                UserDefaults.standard.set([Date()], forKey: "clockOuts")
            }
            
            UserDefaults.standard.set(nil, forKey: "clockedIn")
        }
        
        UserDefaults.standard.synchronize()
    }
}
