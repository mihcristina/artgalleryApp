//
//  Colors+Extension.swift
//  ArtGalleryApp
//
//  Created by Michelli Cristina de Paulo Lima on 26/05/25.
//

import UIKit

extension UIColor {

    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red   = CGFloat((hex >> 16) & 0xFF) / 255.0
        let green = CGFloat((hex >> 8) & 0xFF) / 255.0
        let blue  = CGFloat(hex & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        var hexFormatted = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted.remove(at: hexFormatted.startIndex)
        }
        
        guard hexFormatted.count == 6, let hexNumber = Int(hexFormatted, radix: 16) else {
            return nil
        }
        
        self.init(hex: hexNumber, alpha: alpha)
    }

}

extension UIColor {
    static let backgroundColor = UIColor(hex: 0xF1F4F9)
    static let blackLight = UIColor(hex: 0x686868)
}
