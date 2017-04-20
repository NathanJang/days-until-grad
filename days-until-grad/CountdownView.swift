//
//  CountdownView.swift
//  days-until-grad
//
//  Created by Jonathan Chan on 2016-03-19.
//  Copyright © 2016 Jonathan Chan. All rights reserved.
//

import UIKit

class CountdownView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    static var views = [weak CountdownView]()
    
    private let numberLabel = UILabel()
    private let textLabel = UILabel()
    
    static var sharedTimer: NSTimer?
    static var textColor: UIColor {
        get {
            return self.textColor
        }
        set {
            self.numberLabel
        }
    }
}
