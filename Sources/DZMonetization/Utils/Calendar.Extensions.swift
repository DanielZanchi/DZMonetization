//
//  File.swift
//  
//
//  Created by Daniel Zanchi on 27/06/22.
//

import Foundation

extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        
        let diff = from.timeIntervalSinceReferenceDate - to.timeIntervalSinceReferenceDate
        let diffComponents = dateComponents([.minute], from: Date(timeIntervalSinceReferenceDate: diff))
        print("§§ number of days since last receipt update: \(diffComponents.minute)")
        return diffComponents.minute ?? -1
        let fromDate = startOfDay(for: from)
        let toDate = startOfDay(for: to)
        let numberOfDays = dateComponents([.minute], from: fromDate, to: toDate)
        return numberOfDays.minute ?? -1
    }
}
