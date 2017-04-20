//
//  GraduationDates.swift
//  days-until-grad
//
//  Created by Jonathan Chan on 2016-02-18.
//  Copyright © 2016 Jonathan Chan. All rights reserved.
//

import Foundation

/// Rounds `x` divided by `y` to the nearest integer, including negative numbers.
private func roundedDivision(divisor x: Double, dividend y: Double) -> Int? {
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

/// Handles dates etc.
struct GraduationDate {
    static let graduationDate = GraduationDate(date: NSDate(timeIntervalSince1970: 1464364800), subject: "Graduation")
    static let promDate = GraduationDate(date: NSDate(timeIntervalSince1970: 1461409200), subject: "prom")
    
    private let date: NSDate
    let subject: String
    
    init(date: NSDate, subject: String) {
        self.date = date
        self.subject = subject
    }    
    
    private func roundedSecondsLeft() -> Int {
        return roundedDivision(divisor: self.date.timeIntervalSinceNow, dividend: 1)!
    }
    
    private func roundedMinutesLeft() -> Int {
        return roundedDivision(divisor: self.date.timeIntervalSinceNow, dividend: 60)!
    }
    
    private func roundedHoursLeft() -> Int {
        return roundedDivision(divisor: self.date.timeIntervalSinceNow, dividend: 60 * 60)!
    }
    
    private func roundedDaysLeft() -> Int {
        return self.roundedDaysUntil(NSDate())
    }
    
    /// Rounds up for positive numbers, down for negative numbers.
    func roundedDaysUntil(date: NSDate) -> Int {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Era, .Year, .Month, .Day], fromDate: date)
        let roundedDate = calendar.dateFromComponents(components)
        let daysLeft = self.date.timeIntervalSinceDate(roundedDate!) / 60 / 60 / 24
        if daysLeft >= 0 {
            return Int(daysLeft)
        } else {
            return Int(daysLeft - 1)
        }
    }
    
    func readableTimeLeft() -> ReadableTimeLeft {
        let number: Int
        let unit, comparator: String
        
        let secondsLeft = self.roundedSecondsLeft(),
            minutesLeft = self.roundedMinutesLeft(),
            hoursLeft = self.roundedHoursLeft(),
            daysLeft = self.roundedDaysLeft()
        
        if secondsLeft >= 0 {
            comparator = "until"
            if secondsLeft < 60 {
                number = secondsLeft
                unit = secondsLeft != 1 ? "seconds" : "second"
            } else if minutesLeft < 60 {
                number = minutesLeft
                unit = minutesLeft != 1 ? "minutes" : "minute"
            } else if hoursLeft < 24 {
                number = hoursLeft
                unit = hoursLeft != 1 ? "hours" : "hour"
            } else {
                number = daysLeft
                unit = "days"
            }
        } else {
            comparator = "since"
            if secondsLeft > -60 {
                number = -secondsLeft
                unit = secondsLeft != -1 ? "seconds" : "second"
            } else if minutesLeft > -60 {
                number = -minutesLeft
                unit = minutesLeft != -1 ? "minutes" : "minute"
            } else if hoursLeft > -24 {
                number = -hoursLeft
                unit = hoursLeft != -1 ? "hours" : "hour"
            } else {
                number = -daysLeft
                unit = "days"
            }
        }
        
        return ReadableTimeLeft(number: number, text: ReadableTimeLeftText(unit: unit, comparator: comparator, subject: self.subject))
    }
}

struct ReadableTimeLeft {
    let number: Int
    let text: ReadableTimeLeftText
    
    private init(number: Int, text: ReadableTimeLeftText) {
        self.number = number
        self.text = text
    }
}

struct ReadableTimeLeftText {
    let unit: String // e.g. days
    let comparator: String // e.g. until
    let subject: String // e.g. graduation
    
    private init(unit: String, comparator: String, subject: String) {
        self.unit = unit
        self.comparator = comparator
        self.subject = subject
    }
}

extension ReadableTimeLeftText: CustomStringConvertible {
    var description: String {
        return "\(self.unit) \(self.comparator) \(self.subject)"
    }
}
