//
//  File.swift
//  
//
//  Created by Daniel Zanchi on 14/03/22.
//

import SwiftUI

extension Color {
    @available(iOS 14.0, *)
    public func modified(withAdditionalHue hue: CGFloat, additionalSaturation: CGFloat, additionalBrightness: CGFloat, additionalAlpha: CGFloat) -> Color {
        
        var uiColor = self.uiColor
        
        uiColor = uiColor.modified(withAdditionalHue: hue, additionalSaturation: additionalSaturation, additionalBrightness: additionalBrightness, additionalAlpha: additionalAlpha)
        
        return Color(uiColor)
    }
}

extension Color {
    
    @available(iOS 14.0, *)
    public var uiColor: UIColor {
        UIColor(self)
    }
    
}

extension UIColor {
    public func modified(withAdditionalHue hue: CGFloat, additionalSaturation: CGFloat, additionalBrightness: CGFloat, additionalAlpha: CGFloat) -> UIColor {
        
        var currentHue: CGFloat = 0.0
        var currentSaturation: CGFloat = 0.0
        var currentBrigthness: CGFloat = 0.0
        var currentAlpha: CGFloat = 0.0
        
        if self.getHue(&currentHue, saturation: &currentSaturation, brightness: &currentBrigthness, alpha: &currentAlpha) {
            currentHue = currentHue * 360
            currentSaturation = currentSaturation * 100
            currentBrigthness = currentBrigthness * 100
            
            let resultSaturation = (currentSaturation + additionalSaturation) > 100 ? 100 : currentSaturation + additionalSaturation
            let resultBrightness = (currentBrigthness + additionalBrightness) > 100 ? 100 : (currentBrigthness + additionalBrightness)
            let resultAlpha = (currentAlpha + additionalAlpha) > 1 ? 1 : (currentAlpha + additionalAlpha)
            
            return UIColor(h: Int(currentHue + hue),
                           s: Int(resultSaturation),
                           b: Int(resultBrightness),
                           alpha: (resultAlpha))
        } else {
            return self
        }
    }
    
    public convenience init(h: Int, s: Int, b: Int, alpha: CGFloat) {
        self.init(
            hue: CGFloat(h) / 360,
            saturation: CGFloat(s) / 100,
            brightness: CGFloat(b) / 100,
            alpha: CGFloat(alpha)
        )
    }
}
