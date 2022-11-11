//
//  PolicyView.swift
//  AnimatedSticker
//
//  Created by Daniel Zanchi on 28/09/21.
//  Copyright © 2021 Daniel Zanchi. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
public struct PolicyView: View {
    let dismiss: (() -> Void)
    private let appName: String = DZMonetization.shared.getAppName() ?? ""
    private let price: String = DZMonetization.shared.getPriceForTersm() ?? ""

    public init(dismiss: @escaping (() -> Void)) {
        self.dismiss = dismiss
    }
    
    public var body: some View {
        ZStack() {
            if #available(iOS 14.0, *) {
                Color.white
                    .ignoresSafeArea()
            } else {
                Color.white
            }
            VStack {
                HStack() {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.black.opacity(0.8))
                            .padding(.leading, 12)
                            .padding(.top, 12)
                    })
                    Spacer()
                }
            Spacer()
            }
            VStack {
                HStack() {
                    Text("Privacy Policy")
                        .font(.headline)
                        .padding(16)
                }
            Spacer()
            }
            ScrollView {
            Text(
                """
                1. Privacy policy
                To access  \(appName) unlimited features you can subscribe.
                Auto-renewing subscription (“Weekly Premium”) price is \(price) USD / \(price) EUR per week; length of subscription is one week (Auto-renewing)
                prices vary by country; please check the specific terms that apply to you at the time of purchase, displayed in the app and on the purchase confirmation alert.
                Payment is charged to iTunes Account at the confirmation of the purchase.
                Subscription automatically renews for the same price and duration period unless auto renew is turned off at least 24 hours before the end of the current period.
                Account will be charged for renewal within 24 hours prior the end of the current period at the cost of the weekly package.
                Subscriptions may be managed by the user and auto renewal may be turned off by logging to the users iTunes Account Settings.
                No cancellation of the current subscription is allowed during active subscription period.
                You may cancel a subscription during its free trial period via the subscription setting in the logging to the users iTunes Account. This must be done 24 hours before the end of the subscription period to avoid being charged.
                Unused portions of a free-trial period are forfeited upon subscription purchase.
                Please visit https://support.apple.com/ for more information.
            """
            )
            .font(.caption)
            .foregroundColor(.black)
        }
            .padding()
            .padding(.top, 34)
        }
    }
}
