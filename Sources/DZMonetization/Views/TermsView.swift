//
//  TermsView.swift
//  StickersCreator
//
//  Created by Daniel Zanchi on 17/02/21.
//  Copyright © 2021 Daniel Zanchi. All rights reserved.
//

import SwiftUI

public struct TermsView: View {
    @Binding var isShowingView: Bool
    private let appName: String = DZMonetization.shared.getAppName() ?? ""
    private let price: String = DZMonetization.shared.getPriceForTersm() ?? ""
    
    var body: some View {
        
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
                        isShowingView.toggle()
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
                    Text("Terms & Conditions")
                        .font(.headline)
                        .padding(16)
                }
            Spacer()
            }
            ScrollView {
            Text(
                """
             1. Terms
            By using \(appName), you are agreeing to be bound by these terms of use, all applicable laws and regulations, and agree that you are responsible for compliance with any applicable local laws. If you do not agree with any of these terms, you are prohibited from using the App. The materials contained in this App are protected by applicable copyright and trademark law.
            2. Use License
            Permission is granted to temporarily download one copy of the materials (information or software) for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title, and under this license you may not:
            modify or copy the materials;
            use the materials for any commercial purpose, or for any public display (commercial or non-commercial);
            attempt to decompile or reverse engineer any software contained within the app;
            remove any copyright or other proprietary notations from the materials;
            transfer the materials to another person or “mirror” the materials on any other server.
            This license shall automatically terminate if you violate any of these restrictions and may be terminated by \(appName) at any time. Upon terminating your viewing of these materials or upon the termination of this license, you must destroy any downloaded materials in your possession whether in electronic or printed format.
            3. Disclaimer
            The materials within \(appName) are provided on an ‘as is’ basis. \(appName) makes no warranties, expressed or implied, and hereby disclaims and negates all other warranties including, without limitation, implied warranties or conditions of merchantability, fitness for a particular purpose, or non-infringement of intellectual property or other violation of rights.
            Furthermore, \(appName) does not warrant or make any representations concerning the accuracy, likely results, or reliability of the use of the materials within the app.
            4. Limitations
            In no event shall \(appName) or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption) arising out of the use or inability to use the App and the materials within \(appName), even if \(appName) authorized representative has been notified orally or in writing of the possibility of such damage. Because some jurisdictions do not allow limitations on implied warranties, or limitations of liability for consequential or incidental damages, these limitations may not apply to you.
            5. Accuracy of materials
            The materials appearing within \(appName) could include technical, typographical, or photographic errors. \(appName) does not warrant that any of the materials on its website are accurate, complete or current. \(appName) may make changes to the materials contained on its website at any time without notice. However \(appName) does not make any commitment to update the materials.
            6. In-App Purchases
            You can subscribe for unlimited access to all features to "Weekly Premium". This subscription includes many features:
                - Create unlimited posts, edit likes, date and verified badge. Create unlimited messages in chats and many other features.
                "Weekly Premium" offers 7 days for free and then \(price) per week. The price of the weekly subscription (7 days) may vary by country.
            7. Payment information
            You can access to limited \(appName) features or you can subscribe for unlimited access to all features.
            Prices vary by country; please check the specific terms that apply to you at the time of purchase, displayed in the app and on the purchase confirmation alert.
            Payment is charged to iTunes Account at the confirmation of the purchase.
            Subscription automatically renews for the same price and duration period unless auto renew is turned off at least 24 hours before the end of the current period.
            Account will be charged for renewal within 24 hours prior the end of the current period at the cost of the weekly package.
            Subscriptions may be managed by the user and auto renewal may be turned off by logging to the users iTunes Account Settings.
            No cancellation of the current subscription is allowed during active subscription period.
            You may cancel a subscription during its free trial period via the subscription setting in the logging to the users iTunes Account. This must be done 24 hours before the end of the subscription period to avoid being charged.
            Unused portions of a free-trial period are forfeited upon subscription purchase.
            Please visit https://support.apple.com/ for more information.
            8. Modifications
            \(appName) may revise these terms of use at any time without notice. By using the App you are agreeing to be bound by the then current version of these terms of use.

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

struct TermsView_Previews: PreviewProvider {
    @State static var isShowing = true
    static var previews: some View {
        TermsView(isShowingView: $isShowing)
    }
}
