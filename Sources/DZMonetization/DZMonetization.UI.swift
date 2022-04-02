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
		static var textButtonColor: Color = .white
		static var buttonRadius: CGFloat = 18
		static var fontDesign: Font.Design = .rounded
		static var descriptionWeight: Font.Weight = .bold
		static var borderColor: Color = .white
		static var shouldUppercase: Bool = false

        public static func configure(paywallBackground: Color,
                                     textColor: Color,
                                     accent: Color,
                                     accentTop: Color,
                                     accentBottom: Color,
									 textButtonColor: Color? = nil,
									 buttonRadius: CGFloat? = 18,
									 fontDesign: Font.Design? = .rounded,
									 descriptionWeight: Font.Weight? = .bold,
									 borderColor: Color? = .white,
									 shouldUppercase: Bool? = false) {
            self.paywallBackground = paywallBackground
            self.textColor = textColor
            self.accent = accent
            self.accentGradient = LinearGradient(colors: [
                accentTop, accentBottom
            ], startPoint: .top, endPoint: .bottom)
            
			self.textButtonColor = textButtonColor ?? textColor
			
            self.enableTrialBoxBackground = paywallBackground.modified(withAdditionalHue: 0, additionalSaturation: 3, additionalBrightness: -3, additionalAlpha: 0)
			
			self.buttonRadius = buttonRadius ?? 18
			self.fontDesign = fontDesign ?? .rounded
			self.descriptionWeight = descriptionWeight ?? .bold
			self.borderColor = borderColor ?? .white
			self.shouldUppercase = shouldUppercase ?? false
        }
        
	}
	
}

extension String {
	func uppercased(_ value: Bool) -> String {
		if value {
			return self.localizedUppercase
		}
		return self
	}
}
