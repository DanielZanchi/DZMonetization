//
//  File.swift
//  
//
//  Created by Daniel Zanchi on 27/06/22.
//

import Foundation

extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from)
        let toDate = startOfDay(for: to)
        let numberOfDays = dateComponents([.minute], from: fromDate, to: toDate)
        print("§§ number of days since last receipt update: \(numberOfDays)")
        return numberOfDays.minute ?? -1
    }
}
