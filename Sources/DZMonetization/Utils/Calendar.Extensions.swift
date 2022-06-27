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
        let diffComponents = dateComponents([.day], from: Date(timeIntervalSinceReferenceDate: diff))
        print("§§ number of days since last receipt update: \(diffComponents.day ?? -1)")
        return diffComponents.minute ?? -1
    }
}
