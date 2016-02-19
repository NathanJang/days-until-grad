//
//  GraduationDates.swift
//  days-until-grad
//
//  Created by Jonathan Chan on 2016-02-18.
//  Copyright © 2016 Jonathan Chan. All rights reserved.
//

import Foundation

/// Handles dates etc.
struct GraduationDates {
    private static let graduationDate = NSDate(timeIntervalSince1970: 1464364800) // 1464364800
    
    /// Rounds `x` divided by `y` to the nearest integer, including negative numbers.
    private static func roundedDivision(divisor x: Double, dividend y: Double) -> Int? {
        if y == 0 { return nil }
        
        let quotient: Double = x / y
        let result: Int
        if (x > 0 && y > 0) || (x < 0 && y < 0) {
            result = Int(quotient + 0.5)
        } else {
            result = Int(quotient - 0.5)
        }
        
        return result
    }
    
    private static func roundedSecondsLeft() -> Int {
        return self.roundedDivision(divisor: self.graduationDate.timeIntervalSinceNow, dividend: 1)!
    }
    
    private static func roundedMinutesLeft() -> Int {
        return self.roundedDivision(divisor: self.graduationDate.timeIntervalSinceNow, dividend: 60)!
    }
    
    private static func roundedHoursLeft() -> Int {
        return self.roundedDivision(divisor: self.graduationDate.timeIntervalSinceNow, dividend: 60 * 60)!
    }
    
    private static func roundedDaysLeft() -> Int {
        return self.roundedDaysUntil(NSDate())
    }
    
    /// Rounds up for positive numbers, down for negative numbers.
    static func roundedDaysUntil(date: NSDate) -> Int {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Era, .Year, .Month, .Day], fromDate: date)
        let roundedDate = calendar.dateFromComponents(components)
        let daysLeft = self.graduationDate.timeIntervalSinceDate(roundedDate!) / 60 / 60 / 24
        if daysLeft >= 0 {
            return Int(daysLeft)
        } else {
            return Int(daysLeft - 1)
        }
    }
    
    static func readableTimeLeft() -> ReadableTimeLeft {
        let number: Int
        let text: String
        
        let secondsLeft = self.roundedSecondsLeft(),
            minutesLeft = self.roundedMinutesLeft(),
            hoursLeft = self.roundedHoursLeft(),
            daysLeft = self.roundedDaysLeft()
        
        if secondsLeft >= 0 {
            if secondsLeft < 60 {
                number = secondsLeft
                text = secondsLeft != 1 ? "SECONDS LEFT" : "SECOND LEFT"
            } else if minutesLeft < 60 {
                number = minutesLeft
                text = minutesLeft != 1 ? "MINUTES LEFT" : "MINUTE LEFT"
            } else if hoursLeft < 24 {
                number = hoursLeft
                text = hoursLeft != 1 ? "HOURS LEFT" : "HOUR LEFT"
            } else {
                number = daysLeft
                text = "DAYS LEFT"
            }
        } else {
            if secondsLeft > -60 {
                number = -secondsLeft
                text = secondsLeft != -1 ? "SECONDS AGO" : "SECOND AGO"
            } else if minutesLeft > -60 {
                number = -minutesLeft
                text = minutesLeft != -1 ? "MINUTES AGO" : "MINUTE AGO"
            } else if hoursLeft > -24 {
                number = -hoursLeft
                text = hoursLeft != -1 ? "HOURS AGO" : "HOUR AGO"
            } else {
                number = -daysLeft
                text = "DAYS AGO"
            }
        }
        
        return ReadableTimeLeft(number: number, text: text)
    }
}

struct ReadableTimeLeft {
    let number: Int
    let text: String
    
    private init(number: Int, text: String) {
        self.number = number
        self.text = text
    }
}
