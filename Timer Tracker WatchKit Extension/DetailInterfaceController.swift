//
//  DetailInterfaceController.swift
//  Timer Tracker
//
//  Created by Daniel Rocha on 14/10/16.
//  Copyright © 2016 Daniel Rocha. All rights reserved.
//

import WatchKit
import Foundation


class DetailInterfaceController: WKInterfaceController {

    @IBOutlet var clockInLabel: WKInterfaceLabel!
    @IBOutlet var clockOutLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        if let dates = context as? [Date] {
            let clockIn = dates[0]
            let clockOut = dates[1]
            
            var formatter = DateFormatter()
            formatter.dateFormat = "MM-dd-yyyy HH:mm"
            
            clockInLabel.setText(formatter.string(from: clockIn))
            clockOutLabel.setText(formatter.string(from: clockOut))
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

}
