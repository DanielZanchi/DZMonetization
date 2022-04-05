//
//  File.swift
//  
//
//  Created by Daniel Zanchi on 05/04/22.
//

import Foundation
import UserNotifications

extension DZMonetization {
	
	class NotificationManager {
		static let shared = NotificationManager()
		private var days = 5
		
		private init() {}
		
		
		func setDaysOfNotification(_ days: Int) {
			self.days = days
		}
		
		func createNotification() {
			let content = UNMutableNotificationContent()
			content.title = "Well done!"
			content.subtitle = "🚀 You are about to become a pro user 🎉"
			
			let calendar = Calendar.current
			if let dateOfNotification = calendar.date(byAdding: .hour, value: 24 * days, to: Date()) {
				askPermission { success, error in
					if success {
						print("date of notification: \(dateOfNotification)")
						let trigger = UNCalendarNotificationTrigger(dateMatching: self.getComponentsFrom(date: dateOfNotification), repeats: false)
						let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
						
						UNUserNotificationCenter.current().add(request)
					}
				}
			}
		}
		
		private func getComponentsFrom(date: Date) -> DateComponents {
			let calendar = Calendar.current
			return calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
		}
		
		private func askPermission(completion: @escaping (Bool, Error?) -> Void) {
			UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
				if success {
					print("notifications are ok")
				} else if let error = error {
					print(error.localizedDescription)
				}
				completion(success, error)
			}
		}
		
	}
}
