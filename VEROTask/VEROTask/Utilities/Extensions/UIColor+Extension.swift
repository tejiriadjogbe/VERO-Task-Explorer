//
//  UIColor+Extension.swift
//  VEROTask
//
//  Created by Adjogbe  Tejiri on 09/06/2024.
//

import UIKit

extension UIColor {
    public static let AppPrimary = UIColor(named: "AppPrimary") ?? UIColor()
    public static let AppSecondary = UIColor(named: "AppSecondary") ?? UIColor()
    public static let AppTetiary = UIColor(named: "Tetiary") ?? UIColor()
    public static let AppBackground = UIColor(named: "Background") ?? UIColor()
    public static let AppBody = UIColor(named: "Body") ?? UIColor()
    public static let AppHeadline = UIColor(named: "Headline") ?? UIColor()
    public static let AppOutline = UIColor(named: "Outline") ?? UIColor()
    
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}


