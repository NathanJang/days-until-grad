//
//  ComplicationController.swift
//  days-until-grad-apple-watch Extension
//
//  Created by Jonathan Chan on 2016-02-17.
//  Copyright © 2016 Jonathan Chan. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.Forward, .Backward])
    }
    
    func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
//        handler(nil)
        handler(NSDate(timeIntervalSince1970: 0))
    }
    
    func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
//        handler(nil)
        handler(NSDate(timeIntervalSince1970: Double(INT_MAX)))
    }
    
    func getPrivacyBehaviorForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.ShowOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {
        // Call the handler with the current timeline entry
        let timelineEntry = self.timelineEntry(family: complication.family, date: NSDate())
        
        handler(timelineEntry)
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, beforeDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries prior to the given date
        var entries = [CLKComplicationTimelineEntry]()
        
        var aDate = date
        for _ in 0..<limit {
            aDate = aDate.dateByAddingTimeInterval(-60 * 60 * 24)
            entries.insert(self.timelineEntry(family: complication.family, date: aDate), atIndex: 0)
        }
//        handler(nil)
        handler(entries)
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries after to the given date
        var entries = [CLKComplicationTimelineEntry]()
        
        var aDate = date
        for _ in 0..<limit {
            aDate = aDate.dateByAddingTimeInterval(60 * 60 * 24)
            entries.append(self.timelineEntry(family: complication.family, date: aDate))
        }
//        handler(nil)
        handler(entries)
    }
    
    // MARK: - Update Scheduling
    
    func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
        // Call the handler with the date when you would next like to be given the opportunity to update your complication content
        handler(nil)
    }
    
    // MARK: - Placeholder Templates
    
    func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        let template = self.template(family: complication.family, date: nil)
        
        handler(template)
    }
    
    func template(family family: CLKComplicationFamily, date: NSDate?) -> CLKComplicationTemplate {
        let template: CLKComplicationTemplate
        let daysLeft: Int? = date != nil ? GraduationDates.roundedDaysUntil(date!) : nil
        
        switch family {
        case .ModularSmall:
            template = self.modularSmallTemplate(daysLeft: daysLeft)
            
        case .ModularLarge:
            template = self.modularLargeTemplate(daysLeft: daysLeft)
            
        case .UtilitarianSmall:
            template = self.utilitarianSmallTemplate(daysLeft: daysLeft)
            
        case .UtilitarianLarge:
            template = self.utilitarianLargeTemplate(daysLeft: daysLeft)
            
        case .CircularSmall:
            template = self.circularSmallTemplate(daysLeft: daysLeft)
        }
        
        return template
    }
    
    func timelineEntry(family family: CLKComplicationFamily, date: NSDate) -> CLKComplicationTimelineEntry {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Era, .Year, .Month, .Day], fromDate: date)
        let roundedDate = calendar.dateFromComponents(components)!
        let template = self.template(family: family, date: roundedDate)
        return CLKComplicationTimelineEntry(date: roundedDate, complicationTemplate: template)
    }
    
    private func modularSmallTemplate(daysLeft daysLeft: Int?) -> CLKComplicationTemplateModularSmallStackText {
        let modularSmallTemplate = CLKComplicationTemplateModularSmallStackText()
        modularSmallTemplate.line1TextProvider = CLKSimpleTextProvider(text: formatDaysLeft(daysLeft))
        modularSmallTemplate.line2TextProvider = CLKSimpleTextProvider(text: pluralizedDaysString(daysLeft: daysLeft).uppercaseString)
        return modularSmallTemplate
    }
    
    private func modularLargeTemplate(daysLeft daysLeft: Int?) -> CLKComplicationTemplateModularLargeStandardBody {
        let modularLargeTemplate = CLKComplicationTemplateModularLargeStandardBody()
        modularLargeTemplate.headerTextProvider = CLKSimpleTextProvider(text: "\(formatDaysLeft(daysLeft)) \(pluralizedDaysString(daysLeft: daysLeft).lowercaseString)")
        modularLargeTemplate.body1TextProvider = CLKSimpleTextProvider(text: "\(daysLeft == nil || (daysLeft != nil && daysLeft >= 0) ? "until" : "since") graduation")
        return modularLargeTemplate
    }
    
    private func utilitarianSmallTemplate(daysLeft daysLeft: Int?) -> CLKComplicationTemplateUtilitarianSmallFlat {
        let utilitarianSmallTemplate = CLKComplicationTemplateUtilitarianSmallFlat()
        utilitarianSmallTemplate.textProvider = CLKSimpleTextProvider(text: "\(formatDaysLeft(daysLeft)) \(pluralizedDaysString(daysLeft: daysLeft).uppercaseString)")
        return utilitarianSmallTemplate
    }
    
    private func utilitarianLargeTemplate(daysLeft daysLeft: Int?) -> CLKComplicationTemplateUtilitarianLargeFlat {
        let utilitarianLargeTemplate = CLKComplicationTemplateUtilitarianLargeFlat()
        utilitarianLargeTemplate.textProvider = CLKSimpleTextProvider(text: "\(formatDaysLeft(daysLeft)) \(pluralizedDaysString(daysLeft: daysLeft).uppercaseString) LEFT")
        return utilitarianLargeTemplate
    }
    
    private func circularSmallTemplate(daysLeft daysLeft: Int?) -> CLKComplicationTemplateCircularSmallStackText {
        let circularSmallTemplate = CLKComplicationTemplateCircularSmallStackText()
        circularSmallTemplate.line1TextProvider = CLKSimpleTextProvider(text: formatDaysLeft(daysLeft))
        circularSmallTemplate.line2TextProvider = CLKSimpleTextProvider(text: pluralizedDaysString(daysLeft: daysLeft).uppercaseString)
        return circularSmallTemplate
    }
    
    private func formatDaysLeft(daysLeft: Int?) -> String {
        if daysLeft != nil {
            if daysLeft >= 0 {
                return "\(daysLeft!)"
            } else {
                return "\(-daysLeft!)"
            }
        } else {
            return "--"
        }
    }
    
    private func pluralizedDaysString(daysLeft daysLeft: Int?) -> String {
        if daysLeft != nil && (daysLeft == 1 || daysLeft == -1) {
            return "day"
        } else {
            return "days"
        }
    }
}
