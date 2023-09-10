//
//  FontContant.swift
//  Howl
//
//  Created by apple on 17/08/23.
//

import Foundation
import UIKit


struct AppFont {
   static var size : CGFloat = 13.0
}

enum Font : String {
    
    case AileronBlack = "Aileron-Black"
    case AileronBlackItalic = "Aileron-BlackItalic"
    case AileronBold = "Aileron-Bold"
    case AileronBoldItalic = "Aileron-BoldItalic"
    case AileronHeavy = "Aileron-Heavy"
    case AileronHeavyItalic = "Aileron-HeavyItalic"
    case AileronItalic = "Aileron-Italic"
    case AileronLight = "Aileron-Light"
    case AileronLightItalic = "Aileron-LightItalic"
    case AileronRegular = "Aileron-Regular"
    case AileronSemiBold = "Aileron-SemiBold"
    case AileronSemiBoldItalic = "Aileron-SemiBoldItalic"
    case AileronThin = "Aileron-Thin"
    case AileronThinItalic = "Aileron-ThinItalic"
    case AileronUltraLight = "Aileron-UltraLight"
    case AileronUltraLightItalic = "Aileron-UltraLightItalic"
    
    
}

extension UIFont {
    static func appFont(_ name: Font, size : CGFloat) -> UIFont {
        return UIFont.init(name: name.rawValue, size: size)!
    }
}
