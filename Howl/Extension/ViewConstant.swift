//
//  ViewConstant.swift
//  Howl
//
//  Created by apple on 29/08/23.
//

import Foundation
import UIKit

let inputBarLight = "#fafafa"

//MARK: BACKGROUND INPUT VIEW
func prepareViewBackground(initialiser: UIViewController) -> UIView {
    
    // Force background colour regardless of light or dark mode
    initialiser.view.backgroundColor = inputBarLight.colorWithHexString()
    
    // Apply the interaction layer
    let interactionLayer = UIView(frame: CGRect(x: 15,
                                                y: 15,
                                                width: DeviceType.SCREEN_WIDTH - 30,
                                                height: DeviceType.SCREEN_HEIGHT - 30))
    interactionLayer.backgroundColor = .white
    
    if DeviceType.SquareCornerRads5 {
        
        interactionLayer.layer.cornerRadius = 5
    }
    
    if DeviceType.RounedCornerRads39 {
        
        interactionLayer.layer.cornerRadius = 39
    }
    
    interactionLayer.layer.shadowColor = UIColor.black.cgColor
    interactionLayer.layer.shadowOffset = CGSize(width: 0, height: 0)
    interactionLayer.layer.shadowRadius = 10
    interactionLayer.layer.shadowOpacity = 0.7
    
    initialiser.view.addSubview(interactionLayer)
    initialiser.view.sendSubviewToBack(interactionLayer)
    
    return interactionLayer
}

extension String{
    func colorWithHexString() -> UIColor {
        
        let hex = trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        
        guard let int = Scanner(string: hex).scanInt32(representation: .hexadecimal) else { return #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) }
        
        let a, r, g, b: Int32
        switch hex.count {
        case 3:     (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)  // RGB (12-bit)
        case 6:     (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)                    // RGB (24-bit)
        case 8:     (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)       // ARGB (32-bit)
        default:    (a, r, g, b) = (255, 0, 0, 0)
        }
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 255.0)
    }
}

struct DeviceType {
    
    // iDevice detection code
    static let IS_IPAD             = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE           = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_RETINA           = UIScreen.main.scale >= 2.0
    
    static let SCREEN_WIDTH        = Int(UIScreen.main.bounds.size.width)
    static let SCREEN_HEIGHT       = Int(UIScreen.main.bounds.size.height)
    static let SCREEN_MAX_LENGTH   = Int( max(SCREEN_WIDTH, SCREEN_HEIGHT) )
    static let SCREEN_MIN_LENGTH   = Int( min(SCREEN_WIDTH, SCREEN_HEIGHT) )
    
    static let IPHONE_2G_3G_3GS_4_4S                = IS_IPHONE && SCREEN_MAX_LENGTH == 480
    static let IPHONE_5_5S_5C_SE                    = IS_IPHONE && SCREEN_MAX_LENGTH == 568
    static let IPHONE_6_6S_7_8                      = IS_IPHONE && SCREEN_MAX_LENGTH == 667
    static let IPHONE_6P_6SP_7P_8P                  = IS_IPHONE && SCREEN_MAX_LENGTH == 736
    static let IPHONE_11Pro_X_XS_12PMini_13Mini     = IS_IPHONE && SCREEN_MAX_LENGTH == 812
    static let IPHONE_12_12Pro_13_13Pro             = IS_IPHONE && SCREEN_MAX_LENGTH == 844
    static let IPHONE_11ProMax_XSMax                = IS_IPHONE && SCREEN_MAX_LENGTH == 896
    static let IPHONE_12ProMax_13ProMax             = IS_IPHONE && SCREEN_MAX_LENGTH == 926
    
    static let SquareCornerRads5  = SCREEN_MAX_LENGTH <= 736
    static let RounedCornerRads39 = SCREEN_MAX_LENGTH > 736
}

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
} 
