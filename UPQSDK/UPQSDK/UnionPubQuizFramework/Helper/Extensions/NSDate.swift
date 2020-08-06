//
//  NSDate.swift
 
//
//  Created by Krishan Kumar on 01/10/18.
//  Copyright © 2018 Krishan Kumar. All rights reserved.
//

import UIKit

extension Date {

	func addDays(dayToAdd:Int)->Date{
		let newDate=Calendar.current.date(byAdding: .day, value: dayToAdd, to: self)
		return newDate ?? Date()
	}
    
    func addYears(yearToAdd:Int)->Date{
        let newDate=Calendar.current.date(byAdding: .year, value: yearToAdd, to: self)
        return newDate ?? Date()
    }
    
    // Returns the amount of years from another date
    func subtractYearsFromCurrentDate() -> Int {
        return Calendar.current.dateComponents([.year], from: self, to: Date()).year ?? 0
    }
	func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
		
		let currentCalendar = Calendar.current
		
		guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
		guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
		
		return end - start
	}
    
    func currenrtDate(formate:String="dd MMM yyyy")->String{
        let currentDateTime = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formate
         return dateFormatter.string(from: currentDateTime)
        
    }
  
    func currentTiemStamp() -> String {
        return "\(Int64(self.timeIntervalSince1970 * 1000))"
    }
    
}
extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    
    static var timestamp: String {
        return "\(Date().millisecondsSince1970)"
    }
    
}
