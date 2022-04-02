//
//  File.swift
//  
//
//  Created by Daniel Zanchi on 02/04/22.
//

import UIKit
import SwiftUI
import DZDataAnalytics

public protocol DZMonetizationPresenter where Self: UIViewController {
	func presentEnableTrialPaywall(helper: String?, completion: (() -> Void)?)
}

extension DZMonetizationPresenter {
	func presentEnableTrialPaywall(helper: String? = nil, completion: completionVoid) {
		guard DZMonetization.AppData.shared.isPremium() == false else { completion?(); return }
		if let helper = helper {
			DZDataAnalytics.DataProvider.current.set(paywallName: "enableTrial", trigger: helper)
		}
		let paywallView = EnableTrialPaywallView(productIdWithTrial: DZMonetization.shared.activePaywallConfiguration.trialId, productIdNoTrial: DZMonetization.shared.activePaywallConfiguration.noTrialId, isHardPaywall: DZMonetization.shared.activePaywallConfiguration.isHardPaywall, dismiss: { self.dismiss(animated: false) {
			completion?()
		} })
		let paywallViewController = UIHostingController(rootView: paywallView)
		paywallViewController.modalPresentationStyle = .overFullScreen
		self.present(paywallViewController, animated: false)
	}
}
