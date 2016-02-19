//
//  ViewController.swift
//  days-until-grad
//
//  Created by Jonathan Chan on 2016-02-17.
//  Copyright © 2016 Jonathan Chan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.numberLabel.translatesAutoresizingMaskIntoConstraints = false
        self.numberLabel.font = UIFont(name: "Avenir", size: 72)
        self.view.addSubview(self.numberLabel)
        self.view.addConstraint(NSLayoutConstraint(item: self.numberLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.numberLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 0.85, constant: 0))
        
        self.textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.textLabel.font = UIFont(name: "AvenirLight", size: 12)
        self.view.addSubview(self.textLabel)
        self.view.addConstraint(NSLayoutConstraint(item: self.textLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.textLabel, attribute: .Top, relatedBy: .Equal, toItem: self.numberLabel, attribute: .Bottom, multiplier: 1, constant: 0))
        
        self.redoLabels()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "redoLabels", userInfo: nil, repeats: true)
        
        self.redoColors()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "didTap:")
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    let numberLabel = UILabel()
    let textLabel = UILabel()
    
    var timer: NSTimer?
    
    private func randomCGFloat() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
    
    /// Refreshes the labels.
    func redoLabels() {        
        let timeLeft = GraduationDates.readableTimeLeft()
        
        self.numberLabel.text = "\(timeLeft.number)"
        self.textLabel.text = timeLeft.text
        
        self.numberLabel.sizeToFit()
        self.textLabel.sizeToFit()
    }
    
    /// Sets the colors to a new random color combination.
    private func redoColors() {
        let backgroundColorBrightness = self.randomCGFloat()
        let backgroundColor = UIColor(hue: self.randomCGFloat(), saturation: 0.5 * self.randomCGFloat(), brightness: backgroundColorBrightness, alpha: 1)
        let textColor: UIColor
        if backgroundColorBrightness < 0.75 {
            textColor = UIColor.whiteColor()
            UIApplication.sharedApplication().statusBarStyle = .LightContent
            
        } else {
            textColor = UIColor.blackColor()
            UIApplication.sharedApplication().statusBarStyle = .Default
        }
        
        self.view.backgroundColor = backgroundColor
        self.numberLabel.textColor = textColor
        self.textLabel.textColor = textColor
    }
    
    /// Animates `redoColors` in 0.5 seconds.
    private func scheduleRedoColors() {
        UIView.animateWithDuration(0.5, animations: {
            self.redoColors()
        })
    }
    
    /// Handles tapping `self.view`.
    func didTap(sender: UITapGestureRecognizer) {
        self.scheduleRedoColors()
    }
}

