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
        
        self.scrollView.frame = CGRect(origin: CGPoint.zero, size: self.view.frame.size)
        self.scrollView.contentSize = CGSize(width: 2 * self.view.frame.width, height: self.view.frame.height)
        self.scrollView.pagingEnabled = true
        self.view.addSubview(self.scrollView)
        
        self.numberLabel.translatesAutoresizingMaskIntoConstraints = false
        self.numberLabel.font = UIFont(name: "Avenir", size: 72)
        self.scrollView.addSubview(self.numberLabel)
        self.scrollView.addConstraint(NSLayoutConstraint(item: self.numberLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self.scrollView, attribute: .CenterX, multiplier: 1, constant: 0))
        self.scrollView.addConstraint(NSLayoutConstraint(item: self.numberLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self.scrollView, attribute: .CenterY, multiplier: 0.85, constant: 0))
        
        self.textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.textLabel.font = UIFont(name: "AvenirLight", size: 12)
        self.scrollView.addSubview(self.textLabel)
        self.scrollView.addConstraint(NSLayoutConstraint(item: self.textLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self.numberLabel, attribute: .CenterX, multiplier: 1, constant: 0))
        self.scrollView.addConstraint(NSLayoutConstraint(item: self.textLabel, attribute: .Top, relatedBy: .Equal, toItem: self.numberLabel, attribute: .Bottom, multiplier: 1, constant: 0))
        
        self.redoLabels()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "redoLabels", userInfo: nil, repeats: true)
        
        self.setRandomColors()
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "didTap:")
//        self.view.addGestureRecognizer(tapGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var scrollView = UIScrollView()

    let numberLabel = UILabel()
    let textLabel = UILabel()
    
    var timer: NSTimer?
    
    private func randomCGFloat() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
    
    /// Refreshes the labels.
    func redoLabels() {        
        let timeLeft = GraduationDate.graduationDate.readableTimeLeft()
        
        self.numberLabel.text = "\(timeLeft.number)"
        self.textLabel.text = "\(timeLeft.text)"
        
        self.numberLabel.sizeToFit()
        self.textLabel.sizeToFit()
    }
    
    /// Sets the colors to a new random color combination.
    private func setRandomColors() {
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
    
    /// Animates `setRandomColors()` in 0.5 seconds.
    private func scheduleSetRandomColors() {
        UIView.animateWithDuration(0.5, animations: {
            self.setRandomColors()
        })
    }
    
    /// Handles tapping `self.view`.
    func didTap(sender: UITapGestureRecognizer) {
        self.scheduleSetRandomColors()
    }
}

