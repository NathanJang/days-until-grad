//
//  InterfaceController.swift
//  days-until-grad-apple-watch Extension
//
//  Created by Jonathan Chan on 2016-02-17.
//  Copyright © 2016 Jonathan Chan. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        
        self.redoLabels()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "redoLabels", userInfo: nil, repeats: true)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBOutlet var numberLabel: WKInterfaceLabel!
    @IBOutlet var textLabel: WKInterfaceLabel!
    
    var timer: NSTimer?
    
    func redoLabels() {
        let timeLeft = GraduationDates.readableTimeLeft()
        
        self.numberLabel.setText("\(timeLeft.number)")
        self.textLabel.setText(timeLeft.text)
    }
}
