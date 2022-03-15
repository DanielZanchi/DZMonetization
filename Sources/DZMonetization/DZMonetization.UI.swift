//
//  File.swift
//  
//
//  Created by Daniel Zanchi on 15/03/22.
//

import SwiftUI

public extension DZMonetization {
    
    class UI {
        
        static var accent: Color = .clear
        static var paywallBackground: Color = .clear
        static var textColor: Color = .clear
        static var accentGradient: LinearGradient = LinearGradient(colors: [], startPoint: .top, endPoint: .bottom)
        static var enableTrialBoxBackground: Color = .clear

        public static func configure(paywallBackground: Color,
                                     textColor: Color,
                                     accent: Color,
                                     accentTop: Color,
                                     accentBottom: Color) {
            self.paywallBackground = paywallBackground
            self.textColor = textColor
            self.accent = accent
            self.accentGradient = LinearGradient(colors: [
                accentTop, accentBottom
            ], startPoint: .top, endPoint: .bottom)
            
            self.enableTrialBoxBackground = paywallBackground.modified(withAdditionalHue: 0, additionalSaturation: 4, additionalBrightness: -4, additionalAlpha: 0)
        }
        
    }
    
}
