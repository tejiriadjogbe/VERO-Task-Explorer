//
//  Fonts.swift
//  VEROTask
//
//  Created by Adjogbe  Tejiri on 09/06/2024.
//

import UIKit

public enum Fonts: String {
    case Bold = "NunitoSans-Bold"
    case Regular = "NunitoSans-Regular"
    case SemiBold = "NunitoSans-SemiBold"
    
    public static func getFont(name: Fonts, _ size: CGFloat ) -> UIFont {
        UIFont(name: name.rawValue, size: size) ?? UIFont()
    }
}

